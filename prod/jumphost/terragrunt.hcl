include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    public_subnet_1_id = "fake___public_subnet_1_id"
    security_group_dmz_id = "fake__security_group_dmz_id"
  }
}

dependency "iam" {
  config_path = "../iam"
  mock_outputs_allowed_terraform_commands = [
    "validate", "plan"]

  mock_outputs = {
    admin_key_name = "fake___admin_key_name"
    aws_iam_instance_profile_ec2_name = "fake__aws_iam_instance_profile_ec2_name"
  }
}

inputs = {
  iam__admin_key_name = dependency.iam.outputs.admin_key_name
  iam__aws_iam_instance_profile_ec2_name = dependency.iam.outputs.aws_iam_instance_profile_ec2_name
  vpc__public_subnet_1_id = dependency.vpc.outputs.public_subnet_1_id
  vpc__security_group_dmz_id = dependency.vpc.outputs.security_group_dmz_id
}
