include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
}

dependency "iam" {
  config_path = "../iam"
}

inputs = {
  iam__admin_key_name = dependency.iam.outputs.admin_key_name
  iam__aws_iam_instance_profile_ec2_name = dependency.iam.outputs.aws_iam_instance_profile_ec2_name
  vpc__public_subnet_1_id = dependency.vpc.outputs.public_subnet_1_id
  vpc__security_group_dmz_id = dependency.vpc.outputs.security_group_dmz_id
}
