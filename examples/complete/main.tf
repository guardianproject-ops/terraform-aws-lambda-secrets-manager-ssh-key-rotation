provider "aws" {
  region = var.region
}

module "rotate_ssh" {
  source = "../../"

  context               = module.this.context
  attributes            = ["ssh-key-rotate"]
  server_username       = "admin"
  tag_name              = "RotateSSHKeys"
  tag_value             = "true"
  secret_prefix         = "${module.this.id}/ssh_*"
  attach_network_policy = false

  # enable for debugging
  lambda_log_level       = "DEBUG"
  lambda_timeout_seconds = 120
}
