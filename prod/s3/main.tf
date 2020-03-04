//provider "aws" {
//  region = var.aws_region
//}
//
//terraform {
//  required_version = ">= 0.12.20"
//
//  backend "s3" {
//    encrypt        = "true"
//    bucket         = "acme-development-terraform-remote-state"
//    key            = "s3.tfstate"
//    region         = "eu-central-1"
//    dynamodb_table = "terraform-lock"
//  }
//}

module "s3" {
  source                  = "../../modules/s3"
  env                     = var.env
  organization            = var.organization
  aws_region              = var.aws_region
  lambda_functions_bucket = var.lambda_functions_bucket
}