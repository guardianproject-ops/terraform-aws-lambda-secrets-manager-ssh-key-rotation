# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
import boto3
import traceback
import os
import sys
import json
import re
from aws_lambda_powertools import Logger


import ssh
from ssm import SSM

logger = Logger()

# Top-level element names for JSON structure in SecretString
PUBLIC_KEY = "PublicKey"
PRIVATE_KEY = "PrivateKey"

# Global environment variables
USERNAME = os.environ["USERNAME"]
TARGETS = ""


@logger.inject_lambda_context
def lambda_handler(event, context):
    """Secrets Manager Rotation Template

    This is a template for creating an AWS Secrets Manager rotation lambda

    Args:
        event (dict): Lambda dictionary of event parameters. These keys must include the following:
            - SecretId: The secret ARN or identifier
            - ClientRequestToken: The ClientRequestToken of the secret version
            - Step: The rotation step (one of createSecret, setSecret, testSecret, or finishSecret)

        context (LambdaContext): The Lambda runtime information

    Raises:
        ResourceNotFoundException: If the secret with the specified arn and stage does not exist

        ValueError: If the secret is not properly configured for rotation

        KeyError: If the event parameters do not contain the expected keys

    """
    logger.debug("event", extra={"event": event})
    tag_name = os.environ["TAGNAME"]
    tag_value = os.environ["TAGVALUE"]

    global TARGETS
    TARGETS = [{"Key": "tag:" + tag_name, "Values": [tag_value]}]
    logger.debug("targets", extra={"targets": TARGETS})

    arn = event["SecretId"]
    token = event["ClientRequestToken"]
    step = event["Step"]

    # Setup the client
    service_client = boto3.client("secretsmanager")

    # Make sure the version is staged correctly
    metadata = service_client.describe_secret(SecretId=arn)
    logger.debug("Metadata", extra={"metadata": metadata})
    if not metadata["RotationEnabled"]:
        logger.info("Secret %s is not enabled for rotation." % arn)
        raise ValueError("Secret %s is not enabled for rotation." % arn)
    versions = metadata["VersionIdsToStages"]
    if token not in versions:
        logger.info(
            "Secret version %s has no stage for rotation of secret %s." % (token, arn)
        )
        raise ValueError(
            "Secret version %s has no stage for rotation of secret %s." % (token, arn)
        )
    if "AWSCURRENT" in versions[token]:
        logger.info(
            "Secret version %s already set as AWSCURRENT for secret %s." % (token, arn)
        )
        return
    elif "AWSPENDING" not in versions[token]:
        logger.info(
            "Secret version %s not set as AWSPENDING for rotation of secret %s."
            % (token, arn)
        )
        raise ValueError(
            "Secret version %s not set as AWSPENDING for rotation of secret %s."
            % (token, arn)
        )

    logger.info("Executing step: %s" % (step))
    if step == "createSecret":
        create_secret(service_client, arn, token, context)

    elif step == "setSecret":
        set_secret(service_client, arn, token, context)

    elif step == "testSecret":
        test_secret(service_client, arn, token, context)

    elif step == "finishSecret":
        finish_secret(service_client, arn, token, context)

    else:
        raise ValueError("Invalid step parameter")


def create_secret(service_client, arn, token, context):
    """Create the secret

    This method first checks for the existence of a secret for the passed in token. If one does not exist, it will generate a
    new secret and put it with the passed in token.

    Args:
        service_client (client): The secrets manager service client

        arn (string): The secret ARN or other identifier

        token (string): The ClientRequestToken associated with the secret version

    Raises:
        ResourceNotFoundException: If the secret with the specified arn and stage does not exist

    """
    try:
        # Make sure the current secret exists
        logger.info("Retrieving current version")
        current_dict = get_secret_dict(service_client, arn, "AWSCURRENT")
        # Now try to get the secret version, if that fails, put a new secret
        service_client.get_secret_value(
            SecretId=arn, VersionId=token, VersionStage="AWSPENDING"
        )
        logger.info("createSecret: Successfully retrieved secret for %s." % arn)
        return
    except service_client.exceptions.ResourceNotFoundException:
        pass

    # Current version does not exist
    # Let's initialize the secret with a new ssh key
    current_dict = dict()
    logger.info("createSecret: Generating a key pair with token %s." % (token))
    [priv, pub] = ssh.generate_key_pair(token)
    logger.info("createSecret: keypair generated, pubkey: %s" % (pub))

    current_dict[PRIVATE_KEY] = priv
    current_dict[PUBLIC_KEY] = pub

    secret_string = json.dumps(current_dict)

    logger.info("createSecret: saving secret value")
    service_client.put_secret_value(
        SecretId=arn,
        ClientRequestToken=token,
        SecretString=secret_string,
        VersionStages=["AWSPENDING"],
    )
    logger.info(
        "createSecret: Successfully put secret for ARN %s and version %s."
        % (arn, token)
    )


def set_secret(service_client, arn, token, context):
    """Set the secret

    This method should set the AWSPENDING secret in the service that the secret belongs to. For example, if the secret is a database
    credential, this method should take the value of the AWSPENDING secret and set the user's password to this value in the database.

    Args:
        service_client (client): The secrets manager service client

        arn (string): The secret ARN or other identifier

        token (string): The ClientRequestToken associated with the secret version

    """
    # This is where the secret should be set in the service
    pending = service_client.get_secret_value(
        SecretId=arn, VersionId=token, VersionStage="AWSPENDING"
    )

    pending_version = pending["VersionId"]

    pending_dict = get_secret_dict(service_client, arn, "AWSPENDING")

    ssm = SSM(context, TARGETS, USERNAME)

    logger.info(
        "setSecret: Invoking Systems Manager to add the new public key with token %s."
        % pending_version
    )
    command_id = ssm.add_public_key(pending_dict[PUBLIC_KEY], pending_version)
    logger.info(
        "setSecret: Waiting for Systems Manager command %s to complete." % (command_id)
    )
    ssm.wait_completion(command_id)
    logger.info(
        "setSecret: Systems Manager command %s completed successfully." % (command_id)
    )


def test_secret(service_client, arn, token, context):
    """Test the secret

    This method should validate that the AWSPENDING secret works in the service that the secret belongs to. For example, if the secret
    is a database credential, this method should validate that the user can login with the password in AWSPENDING and that the user has
    all of the expected permissions against the database.

    Args:
        service_client (client): The secrets manager service client

        arn (string): The secret ARN or other identifier

        token (string): The ClientRequestToken associated with the secret version

    """
    command = "hostname"
    pending_dict = get_secret_dict(service_client, arn, "AWSPENDING")
    logger.info("testSecret: getting instance IDs for version %s" % (token))
    ssm = SSM(context, TARGETS, USERNAME)
    ip_addresses = ssm.get_addrs_for_add_key(token)
    logger.info(
        "testSecret: Performing SSH test by invoking command '%s' on remote host for user '%s' for ip addresses %s"
        % (command, USERNAME, str(ip_addresses))
    )
    ssh.run_command(ip_addresses, USERNAME, pending_dict[PRIVATE_KEY], command)
    logger.info("testSecret: SSH test succeeded")


def finish_secret(service_client, arn, token, context):
    """Finish the secret

    This method finalizes the rotation process by marking the secret version passed in as the AWSCURRENT secret.

    Args:
        service_client (client): The secrets manager service client

        arn (string): The secret ARN or other identifier

        token (string): The ClientRequestToken associated with the secret version

    Raises:
        ResourceNotFoundException: If the secret with the specified arn does not exist

    """
    # First describe the secret to get the current version
    metadata = service_client.describe_secret(SecretId=arn)

    new_version = token
    current_version = None
    for version in metadata["VersionIdsToStages"]:
        if "AWSCURRENT" in metadata["VersionIdsToStages"][version]:
            if version == token:
                # The correct version is already marked as current, return
                logger.info(
                    "finishSecret: Version %s already marked as AWSCURRENT for %s"
                    % (version, arn)
                )
                return
            current_version = version
            break

    # Finalize by staging the secret version current
    service_client.update_secret_version_stage(
        SecretId=arn,
        VersionStage="AWSCURRENT",
        MoveToVersionId=new_version,
        RemoveFromVersionId=current_version,
    )
    logger.info(
        "finishSecret: Successfully set AWSCURRENT stage to version %s for secret %s."
        % (new_version, arn)
    )

    # after change above:
    prior_version = current_version

    new_dict = get_secret_dict(service_client, arn, "AWSCURRENT")

    ssm = SSM(context, TARGETS, USERNAME)

    logger.info(
        "finishSecret: Invoking Systems Manager to delete the old public key with token %s."
        % (prior_version)
    )
    command_id = ssm.del_public_key(prior_version)
    logger.info(
        "finishSecret: Waiting for Systems Manager command %s to complete."
        % (command_id)
    )
    ssm.wait_completion(command_id)
    logger.info(
        "finishSecret: Systems Manager command %s completed successfully."
        % (command_id)
    )


def get_secret_dict(service_client, arn, stage, token=None):
    """Gets the secret dictionary corresponding for the secret arn, stage, and token

    This helper function gets credentials for the arn and stage passed in and returns the dictionary by parsing the JSON string

    Args:
        service_client (client): The secrets manager service client

        arn (string): The secret ARN or other identifier

        token (string): The ClientRequestToken associated with the secret version, or None if no validation is desired

        stage (string): The stage identifying the secret version

    Returns:
        SecretDictionary: Secret dictionary

    Raises:
        ResourceNotFoundException: If the secret with the specified arn and stage does not exist

        ValueError: If the secret is not valid JSON

        KeyError: If the secret json does not contain the expected keys

    """

    # Only do VersionId validation against the stage if a token is passed in
    if token:
        secret = service_client.get_secret_value(
            SecretId=arn, VersionId=token, VersionStage=stage
        )
    else:
        secret = service_client.get_secret_value(SecretId=arn, VersionStage=stage)
    plaintext = secret["SecretString"]
    secret_dict = json.loads(plaintext)

    # Parse and return the secret JSON string
    return secret_dict
