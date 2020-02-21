terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "certificates.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "route53" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "route53.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}


module "certificates" {
  source       = "../../modules/certificates"
  env          = var.env
  organization = var.organization
  aws_region   = var.aws_region
  zone_id      = data.terraform_remote_state.route53.outputs.zone_id
}