data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "null_resource" "lambda" {
  triggers = {
    build_number = timestamp()
  }
  provisioner "local-exec" {
    command = "cd ${path.module} && make artifact"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/artifacts/lambda"
  output_path = "${path.module}/artifacts/lambda-${null_resource.lambda.triggers.build_number}.zip"
  depends_on  = [null_resource.lambda]
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
  name               = module.this.id
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = module.this.tags
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
      values   = [aws_lambda_function.default.arn]

    }
  }
  statement {
    effect    = "Allow"
    sid       = "SSMRunShellScriptDocument"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}::document/AWS-RunShellScript"]
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
  function_name    = module.this.id
  filename         = data.archive_file.lambda_zip.output_path
  handler          = "rotate.lambda_handler"
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.7"
  timeout          = 300
  tags             = module.this.tags

  environment {
    variables = {
      USERNAME = var.server_username
      TAGNAME  = var.tag_name
      TAGVALUE = var.tag_value
    }
  }
}


resource "aws_lambda_permission" "secretsmanager" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "secretsmanager.amazonaws.com"
  statement_id  = "AllowExecutionFromSecretsManager1"
}

resource "aws_lambda_alias" "default" {
  name             = "default"
  description      = "Use latest version as default"
  function_name    = aws_lambda_function.default.function_name
  function_version = "$LATEST"
}
