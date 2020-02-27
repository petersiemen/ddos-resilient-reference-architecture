provider "aws" {
  region = var.aws_region
}

module "bootstrap" {
  source          = "../../modules/bootstrap"
  tf-state-bucket = var.tf_state_bucket
}