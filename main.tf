module "label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  context    = module.this.context
  attributes = ["lambda"]
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    sid    = "SecretsManagerActions"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage"
    ]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_prefix}"
    ]
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:resource/AllowRotationLambdaArn"
      values   = [module.lambda_function.this_lambda_function_arn]
    }
  }
  statement {
    effect    = "Allow"
    sid       = "SSMRunShellScriptDocument"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}::document/AWS-RunShellScript"]
  }
  statement {
    effect    = "Allow"
    sid       = "SSMRunShellScriptOnTaggedInstances"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*"]
    condition {
      test     = "StringEquals"
      variable = "ssm:resourceTag/${var.tag_name}"
      values   = [var.tag_value]
    }
  }
  statement {
    effect = "Allow"
    sid    = "SSMTrackCommands"
    actions = [
      "ssm:ListCommandInvocations",
      "ssm:GetCommandInvocation",
      "ssm:ListCommands",
      "ssm:DescribeInstanceInformation"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    sid    = "EC2DescribeInstances"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = module.this.id
  description = "Allow rotation of ssh keys on tagged instances"
  policy      = data.aws_iam_policy_document.lambda.json
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = module.label.id
  description   = "Rotates SSH keys on EC2 instances"
  handler       = "rotate.lambda_handler"
  runtime       = var.python_runtime_version
  timeout       = var.lambda_timeout_seconds
  source_path   = "${path.module}/lambda/"
  allowed_triggers = {
    "AllowExecutionFromSecretsManager1" = {
      principal = "secretsmanager.amazonaws.com"
      action    = "lambda:InvokeFunction"
    }
  }
  publish                                 = false
  create_current_version_allowed_triggers = false

  attach_policies = true
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  ]
  number_of_policies                = 2
  cloudwatch_logs_retention_in_days = 14
  cloudwatch_logs_tags              = module.label.tags
  environment_variables = {
    USERNAME  = var.server_username
    TAGNAME   = var.tag_name
    TAGVALUE  = var.tag_value
    LOG_LEVEL = var.lambda_log_level
  }
  tags = module.label.tags
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = module.lambda_function.lambda_role_name
  policy_arn = aws_iam_policy.lambda.arn
}
