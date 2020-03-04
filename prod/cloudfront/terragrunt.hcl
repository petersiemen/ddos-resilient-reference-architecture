include {
  path = find_in_parent_folders()
}

dependency "alb" {
  config_path = "../alb"
}

dependency "waf" {
  config_path = "../waf"
}

dependency "certificates" {
  config_path = "../certificates"
}


inputs = {
  alb__dns_name = dependency.alb.outputs.alb_dns_name
  alb__id = dependency.alb.outputs.alb_id
  waf__web_acl_id = dependency.waf.outputs.web_acl_id
  certificates__acm_certification_arn = dependency.certificates.outputs.acm_certification_arn
}