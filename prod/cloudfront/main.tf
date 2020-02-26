terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "cloudfront.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "alb.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "waf" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "waf.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "certificates" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "certificates.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}

module "cloudfront" {
  source                = "../../modules/cloudfront"
  env                   = var.env
  organization          = var.organization
  aws_region            = var.aws_region
  alb_dns_name          = data.terraform_remote_state.alb.outputs.alb_dns_name
  alb_id                = data.terraform_remote_state.alb.outputs.alb_id
  web_acl_id            = data.terraform_remote_state.waf.outputs.web_acl_id
  acm_certification_arn = data.terraform_remote_state.certificates.outputs.acm_certification_arn
  domain                = var.domain
}