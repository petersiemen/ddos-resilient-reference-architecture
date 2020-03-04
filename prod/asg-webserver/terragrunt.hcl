include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    private_subnet_1_id = "fake___private_subnet_1_id"
    private_subnet_2_id = "fake__private_subnet_2_id"
    private_subnet_3_id = "fake__private_subnet_3_id"
    security_group_private_id = "fake__security_group_private_id"
  }
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    admin_key_name = "fake__admin_key_name"
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    target_group_arn = "fake__target_group_arn"
  }
}

inputs = {
  iam__admin_key_name = dependency.iam.outputs.admin_key_name

  vpc__private_subnet_1_id = dependency.vpc.outputs.private_subnet_1_id
  vpc__private_subnet_2_id = dependency.vpc.outputs.private_subnet_2_id
  vpc__private_subnet_3_id = dependency.vpc.outputs.private_subnet_3_id

  vpc__security_group_private_id = dependency.vpc.outputs.security_group_private_id
  alb__target_group_arn = dependency.alb.outputs.target_group_arn
}