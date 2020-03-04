include {
  path = find_in_parent_folders()
}


dependency "lambda-api-gateway" {
  config_path = "../lambda-api-gateway"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    lambda_function_invoke_arn = "fake__lambda_function_invoke_arn"
    lambda_function_name = "fake__lambda_function_name"
  }
}
dependency "waf" {
  config_path = "../waf"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    web_acl_id = "fake__web_acl_id"
  }
}
dependency "certificates" {
  config_path = "../certificates"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    acm_certification_arn = "fake__acm_certification_arn"
  }
}


inputs = {
  lambda_api_gateway__lambda_function_invoke_arn = dependency.lambda-api-gateway.outputs.lambda_function_invoke_arn
  lambda_api_gateway__lambda_function_name = dependency.lambda-api-gateway.outputs.lambda_function_name
  certificates__acm_certification_arn = dependency.certificates.outputs.acm_certification_arn
  waf__web_acl_id = dependency.waf.outputs.web_acl_id
}
