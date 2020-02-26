terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "iam.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "iam" {
  source               = "../../modules/iam"
  env                  = var.env
  organization         = var.organization
  admin_public_ssh_key = var.admin_public_ssh_key
  developer_name       = var.developer_name
  developer_ssh_key    = var.developer_ssh_key
}