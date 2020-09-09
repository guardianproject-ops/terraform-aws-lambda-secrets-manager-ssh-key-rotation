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

variable "build_number" {
  type        = string
  description = "Any time this value changes, the lambda will be rebuilt from source. The value it self has no meaning."
  default     = "1"
}
