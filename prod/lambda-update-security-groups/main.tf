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



resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  provider  = "aws.us-east-1"
  topic_arn = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
  protocol  = "lambda"
  endpoint  = module.lambda-update-security-groups.aws_lambda_function_arn
}