terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    encrypt = "true"
    bucket  = "acme-development-terraform-remote-state"
    # TODO: find out wheter this code duplication can be prevented somehow. vars seem not to be allowed here
    key            = "vpc.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

module "bootstrap" {
  source        = "../../modules/vpc"
  env           = var.env
  organization  = var.organization
  my_ip_address = var.my_ip_address
}