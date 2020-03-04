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
//    key            = "asg-webserver.tfstate"
//    region         = "eu-central-1"
//    dynamodb_table = "terraform-lock"
//  }
//}
//
//data "terraform_remote_state" "alb" {
//  backend = "s3"
//
//  config = {
//    encrypt        = "true"
//    bucket         = var.tf_state_bucket
//    key            = "alb.tfstate"
//    region         = var.aws_region
//    dynamodb_table = "terraform-lock"
//  }
//}

variable "alb__target_group_arn" {}
variable "iam__admin_key_name" {}
variable "vpc__security_group_private_id" {}
variable "vpc__private_subnet_1_id" {}
variable "vpc__private_subnet_2_id" {}
variable "vpc__private_subnet_3_id" {}

module "asg-webserver" {
  source                         = "../../modules/asg-webserver"
  env                            = var.env
  organization                   = var.organization
  aws_linux_2_ami                = var.aws_linux_2_ami
  aws_az_a                       = var.aws_az_a
  tf_state_bucket                = var.tf_state_bucket
  aws_region                     = var.aws_region
  alb__target_group_arn          = var.alb__target_group_arn
  iam__admin_key_name            = var.iam__admin_key_name
  vpc__security_group_private_id = var.vpc__security_group_private_id
  vpc__private_subnet_1_id       = var.vpc__private_subnet_1_id
  vpc__private_subnet_2_id       = var.vpc__private_subnet_2_id
  vpc__private_subnet_3_id       = var.vpc__private_subnet_3_id


}