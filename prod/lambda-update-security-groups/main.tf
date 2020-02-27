provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "lambda-update-security-groups.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}


module "lambda-update-security-groups" {
  source         = "../../modules/lambda-update-security-groups"
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  handler        = "app.lambda_handler"
  s3_bucket      = var.lambda_functions_bucket
  s3_key         = "v1.0/2556bce27016954f6c7d70ec68022c6f"
}