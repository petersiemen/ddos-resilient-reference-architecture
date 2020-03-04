include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    vpc_id = "fake__vpc_id"
    security_group_lb_id = "fake__security_group_lb_id"
    security_group_cloudfront_g_http = "fake__security_group_cloudfront_g_http"
    security_group_cloudfront_r_http = "fake__security_group_cloudfront_r_http"
    public_subnet_1_id = "fake__public_subnet_1_id"
    public_subnet_2_id = "fake__public_subnet_2_id"
    public_subnet_3_id = "fake__public_subnet_3_id"
  }
}

inputs = {
  vpc__vpc_id = dependency.vpc.outputs.vpc_id
  vpc__security_group_lb_id = dependency.vpc.outputs.security_group_lb_id
  vpc__security_group_cloudfront_g_http = dependency.vpc.outputs.security_group_cloudfront_g_http
  vpc__security_group_cloudfront_r_http = dependency.vpc.outputs.security_group_cloudfront_r_http

  vpc__public_subnet_1_id = dependency.vpc.outputs.public_subnet_1_id
  vpc__public_subnet_2_id = dependency.vpc.outputs.public_subnet_2_id
  vpc__public_subnet_3_id = dependency.vpc.outputs.public_subnet_3_id

}