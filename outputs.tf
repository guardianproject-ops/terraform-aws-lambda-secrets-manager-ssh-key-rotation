output "lambda" {
  value = module.lambda_function
}

output "lambda_arn" {
  value = module.lambda_function.this_lambda_function_arn
}

output "tag_name" {
  value = var.tag_name
}

output "tag_value" {
  value = var.tag_value
}

output "server_username" {
  value = var.server_username
}

output "security_group_id" {
  value = element(concat(aws_security_group.lambda.*.id, [""]), 0)
}
