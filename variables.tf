variable "server_username" {
  type        = string
  default     = "admin"
  description = "Username for the linux user used to login to the instances"
}
variable "tag_name" {
  type        = string
  default     = "RotateSSHKeys"
  description = "Tag name to locate the instances which should be rotated"
}
variable "tag_value" {
  type        = string
  default     = "true"
  description = "Tag value that must be set to locate the instances which should be rotated"
}
variable "secret_prefix" {
  type        = string
  description = "The Secrets Manager secret prefix, including the wild card if you want one. e.g., 'foo-bar/ssh_*'"
}

variable "python_runtime_version" {
  type        = string
  default     = "python3.7"
  description = "lambda function runtime. the same version must be available in the controller's system PATH."
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_id" {
  description = "The VPC id that the lambda will be attached to"
  type        = string
  default     = null
}

variable "attach_network_policy" {
  description = "Controls whether VPC/network policy should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "lambda_timeout_seconds" {
  description = "The maximum time in seconds the lambda is allowed to run."
  type        = number
  default     = 300
}

variable "lambda_log_level" {
  description = "The log level of the lambda function, one of CRITICAl, ERROR, WARNING, INFO, DEBUG"
  type        = string
  default     = "INFO"
}
