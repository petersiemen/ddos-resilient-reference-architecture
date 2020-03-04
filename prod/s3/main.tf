variable "env" {}
variable "organization" {}
variable "aws_region" {}
variable "lambda_functions_bucket" {}

module "s3" {
  source                  = "../../modules/s3"
  env                     = var.env
  organization            = var.organization
  aws_region              = var.aws_region
  lambda_functions_bucket = var.lambda_functions_bucket
}