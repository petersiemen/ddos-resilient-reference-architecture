variable "env" {}
variable "organization" {}
variable "my_ip_address" {}


module "vpc" {
  source        = "../../modules/vpc"
  env           = var.env
  organization  = var.organization
  my_ip_address = var.my_ip_address
}