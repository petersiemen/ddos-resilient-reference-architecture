terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "asg-webserver.tfstate"
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


module "asg-webserver" {
  source               = "../../modules/asg-webserver"
  env                  = var.env
  organization         = var.organization
  aws_linux_2_ami      = var.aws_linux_2_ami
  aws_az_a             = var.aws_az_a
  tf_state_bucket      = var.tf_state_bucket
  aws_region           = var.aws_region
  alb_target_group_arn = data.terraform_remote_state.alb.outputs.target_group_arn

}