remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "acme-development-terraform-remote-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "acme-terraform-lock"
  }
}

generate "provider" {
  path = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = "eu-central-1"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}
EOF
}

terraform {
  extra_arguments "common_vars" {
    commands = [
      "plan",
      "apply",
      "destroy",
      "refresh"]

//    required_var_files = [
//      "${get_parent_terragrunt_dir()}/env.auto.tfvars"
//    ]
  }

}
