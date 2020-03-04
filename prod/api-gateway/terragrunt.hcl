include {
  path = find_in_parent_folders()
}


dependency "lambda-api-gateway" {
  config_path = "../lambda-api-gateway"
}
dependency "waf" {
  config_path = "../waf"
}
dependency "certificates" {
  config_path = "../certificates"
}


inputs = {
  lambda_api_gateway__lambda_function_invoke_arn = dependency.lambda-api-gateway.outputs.lambda_function_invoke_arn
  lambda_api_gateway__lambda_function_name = dependency.lambda-api-gateway.outputs.lambda_function_name
  certificates__acm_certification_arn = dependency.certificates.outputs.acm_certification_arn
  waf__web_acl_id = dependency.waf.outputs.web_acl_id
}
