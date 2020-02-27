provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "waf.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}


module "waf" {
  source       = "../../modules/waf"
  env          = var.env
  organization = var.organization
  aws_region   = var.aws_region
}