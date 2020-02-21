terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "route53.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}


module "route53" {
  source       = "../../modules/route53"
  env          = var.env
  organization = var.organization
  aws_region   = var.aws_region
}