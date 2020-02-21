terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "asg-webserver.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "asg-webserver" {
  source          = "../../modules/asg-webserver"
  env             = var.env
  organization    = var.organization
  aws_linux_2_ami = var.aws_linux_2_ami
  aws_az_a        = var.aws_az_a
  tf_state_bucket = var.tf_state_bucket
  aws_region      = var.aws_region

}