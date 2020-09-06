variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "namespace" {
  type        = string
  description = "Namespace, your org"
}

variable "stage" {
  type        = string
  description = "Environment (e.g. dev, prod, test)"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `database`)"
}
variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g., `one', or `two')"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`Visibility`,`Public`)"
}
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
