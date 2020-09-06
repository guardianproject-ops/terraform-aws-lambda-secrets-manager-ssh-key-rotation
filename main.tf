data "aws_caller_identity" "current" {}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

resource "null_resource" "lambda" {
  triggers {
    build_number = timestamp()
  }
  provisioner "local-exec" {
    command = "make artifact"
  }
}

data "archive_file" "lambda_zip" {
  depends_on = [
    resource.null_resource.lambda
  ]
  type        = "zip"
  source_dir  = "${path.module}/artifacts/lambda"
  output_path = "${path.module}/artifacts/lambda.zip"
}


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

resource "aws_iam_role" "lambda" {
  name               = module.label.id
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = module.label.tags
}


data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
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
      "arn:aws:secretsmanager:&{AWS::Region}:&{AWS::AccountId}:secret:/${module.label.id}/ssh*"
    ]
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:resource/AllowRotationLambdaArn"
      values   = ["arn:aws:lambda:&{AWS::Region}:&{AWS::AccountId}:function:RotateSSH"]
    }
  }
  statement {
    effect    = "Allow"
    sid       = "SSMRunShellScriptDocument"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ssm:&{AWS::Region}::document/AWS-RunShellScript"]
  }
  statement {
    effect    = "Allow"
    sid       = "SSMRunShellScriptOnTaggedInstances"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ec2:&{AWS::Region}:&{AWS::AccountId}:instance/*"]
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
  name        = module.label.id
  description = "Allow rotation of ssh keys on tagged instances"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_eni" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_lambda_function" "default" {
  function_name    = module.label.id
  filename         = "${path.module}/artifacts/lambda.zip"
  handler          = "lambda.handler"
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.6"
  timeout          = 300
  tags             = module.label.tags

  environment {
    variables = {
      USERNAME = var.serve_username
      TAGNAME  = var.tag_name
      TAGVALUE = var.tag_value
    }
  }
}

resource "aws_lambda_alias" "default" {
  name             = "default"
  description      = "Use latest version as default"
  function_name    = aws_lambda_function.default.function_name
  function_version = "$LATEST"
}
