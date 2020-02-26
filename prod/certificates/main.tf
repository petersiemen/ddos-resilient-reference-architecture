terraform {
  required_version = ">= 0.12.20"

  backend "s3" {
    encrypt        = "true"
    bucket         = "acme-development-terraform-remote-state"
    key            = "certificates.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

terraform {
  required_version = ">= 0.12.20"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}


module "certificates" {
  source      = "../../modules/certificates"
  domain_name = "www.${var.domain}"
  subject_alternative_names = [
  var.domain]
  zones = [
    var.domain,
  var.domain]

}