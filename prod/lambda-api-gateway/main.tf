provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "lambda-api-gateway.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}



module "lambda-api-gateway" {
  source         = "../../modules/lambda-api-gateway"
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  handler        = "app.lambda_handler"
  s3_bucket      = var.lambda_functions_bucket
  s3_key         = var.lambda_api_gateway_prefix
}