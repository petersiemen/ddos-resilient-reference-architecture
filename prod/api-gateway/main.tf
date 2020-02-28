provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "api-gateway.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "lambda-api-gateway" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "lambda-api-gateway.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}


module "asg-webserver" {
  source = "../../modules/api-gateway"

  lambda_function_arn        = data.terraform_remote_state.lambda-api-gateway.outputs.lambda_function_arn
  lambda_function_invoke_arn = data.terraform_remote_state.lambda-api-gateway.outputs.lambda_function_invoke_arn
  lambda_function_name       = data.terraform_remote_state.lambda-api-gateway.outputs.lambda_function_name
  api-key                    = "01234567890123456789012345678911"
}