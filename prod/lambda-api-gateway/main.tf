variable "aws_account_id" {}
variable "aws_region" {}
variable "lambda_functions_bucket" {}
variable "lambda_api_gateway_prefix" {}


module "lambda-api-gateway" {
  source         = "../../modules/lambda-api-gateway"
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  handler        = "app.lambda_handler"
  s3_bucket      = var.lambda_functions_bucket
  s3_key         = var.lambda_api_gateway_prefix
}