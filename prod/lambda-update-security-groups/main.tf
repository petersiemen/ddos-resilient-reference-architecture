variable "aws_account_id" {}
variable "aws_region" {}
variable "lambda_functions_bucket" {}
variable "lambda_update_security_groups_prefix" {}


module "lambda-update-security-groups" {
  providers = {
    aws.us-east-1 = aws.us-east-1
  }
  source         = "../../modules/lambda-update-security-groups"
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  handler        = "app.lambda_handler"
  s3_bucket      = var.lambda_functions_bucket
  s3_key         = var.lambda_update_security_groups_prefix
}