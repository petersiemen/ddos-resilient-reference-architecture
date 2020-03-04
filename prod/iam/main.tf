variable "env" {}
variable "organization" {}
variable "aws_region" {}
variable "admin_public_ssh_key" {}
variable "developer_name" {}
variable "developer_ssh_key" {}

module "iam" {
  source               = "../../modules/iam"
  env                  = var.env
  organization         = var.organization
  admin_public_ssh_key = var.admin_public_ssh_key
  developer_name       = var.developer_name
  developer_ssh_key    = var.developer_ssh_key
}