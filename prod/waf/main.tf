variable "env" {}
variable "organization" {}
variable "aws_region" {}

module "waf" {
  source       = "../../modules/waf"
  env          = var.env
  organization = var.organization
  aws_region   = var.aws_region
}