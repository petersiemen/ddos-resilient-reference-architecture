terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "web-server.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "web-server" {
  source          = "../../modules/web-server"
  env             = var.env
  organization    = var.organization
  aws_linux_2_ami = var.aws_linux_2_ami
  aws_region      = var.aws_region
  tf_state_bucket = var.tf_state_bucket
}