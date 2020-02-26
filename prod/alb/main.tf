terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "alb.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "certification" {
  source = "../../modules/certificates"
  domain = var.domain
}

module "alb" {
  source          = "../../modules/alb"
  env             = var.env
  organization    = var.organization
  aws_region      = var.aws_region
  tf_state_bucket = var.tf_state_bucket
  certificate_arn = module.certification.acm_certification_arn
}