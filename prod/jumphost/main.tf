terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt = "true"
    # TODO: find out wheter this code duplication can be prevented somehow. vars seem not to be allowed here
    bucket         = "acme-development-terraform-remote-state"
    key            = "jumphost.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "jumphost" {
  source          = "../../modules/jumphost"
  env             = var.env
  organization    = var.organization
  aws_linux_2_ami = var.aws_linux_2_ami
  aws_region      = var.aws_region
  tf_state_bucket = var.tf_state_bucket
}