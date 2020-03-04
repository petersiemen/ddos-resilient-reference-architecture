include {
  path = find_in_parent_folders()
}


dependency "vpc" {
  config_path = "../vpc"
}

dependency "iam" {
  config_path = "../iam"
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  iam__admin_key_name = dependency.iam.outputs.admin_key_name

  vpc__private_subnet_1_id = dependency.vpc.outputs.private_subnet_1_id
  vpc__private_subnet_2_id = dependency.vpc.outputs.private_subnet_2_id
  vpc__private_subnet_3_id = dependency.vpc.outputs.private_subnet_3_id

  vpc__security_group_private_id = dependency.vpc.outputs.security_group_private_id
  alb__target_group_arn = dependency.alb.outputs.target_group_arn
}