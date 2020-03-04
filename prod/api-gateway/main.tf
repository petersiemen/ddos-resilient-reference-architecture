variable "lambda_api_gateway__lambda_function_invoke_arn" {}
variable "lambda_api_gateway__lambda_function_name" {}
variable "certificates__acm_certification_arn" {}
variable "waf__web_acl_id" {}

module "api-gateway" {
  source                                         = "../../modules/api-gateway"
  domain                                         = var.domain
  api_key                                        = var.api_key
  lambda_api_gateway__lambda_function_invoke_arn = var.lambda_api_gateway__lambda_function_invoke_arn
  lambda_api_gateway__lambda_function_name       = var.lambda_api_gateway__lambda_function_name
  certificates__acm_certification_arn            = var.certificates__acm_certification_arn
  waf__web_acl_id                                = var.waf__web_acl_id
}