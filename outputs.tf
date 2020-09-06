output "lambda" {
  description = "the lambda resource output"
  value       = aws_lambda_function.default
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
