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

module "certificates" {
  source                    = "../../modules/certificates"
  domain_name               = "www.${var.domain}"
  subject_alternative_names = [var.domain]
  zones                     = []
}

module "alb" {
  source          = "../../modules/alb"
  env             = var.env
  organization    = var.organization
  aws_region      = var.aws_region
  tf_state_bucket = var.tf_state_bucket
  certificate_arn = module.certificates.acm_certification_arn
}