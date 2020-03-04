include {
  path = find_in_parent_folders()
}

dependency "alb" {
  config_path = "../alb"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    alb_dns_name = "fake__alb_dns_name"
    alb_id = "fake__alb_id"
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
  alb__dns_name = dependency.alb.outputs.alb_dns_name
  alb__id = dependency.alb.outputs.alb_id
  waf__web_acl_id = dependency.waf.outputs.web_acl_id
  certificates__acm_certification_arn = dependency.certificates.outputs.acm_certification_arn
}