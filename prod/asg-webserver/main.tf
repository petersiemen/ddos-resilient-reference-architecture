variable "env" {}
variable "organization" {}
variable "aws_region" {}
variable "aws_linux_2_ami" {}
variable "aws_az_names" {
  type = list(string)
}

variable "alb__target_group_arn" {}
variable "iam__admin_key_name" {}
variable "vpc__security_group_private_id" {}
variable "vpc__private_subnet_1_id" {}
variable "vpc__private_subnet_2_id" {}
variable "vpc__private_subnet_3_id" {}

module "asg-webserver" {
  source                         = "../../modules/asg-webserver"
  env                            = var.env
  organization                   = var.organization
  aws_linux_2_ami                = var.aws_linux_2_ami
  aws_az_names                   = var.aws_az_names
  aws_region                     = var.aws_region
  alb__target_group_arn          = var.alb__target_group_arn
  iam__admin_key_name            = var.iam__admin_key_name
  vpc__security_group_private_id = var.vpc__security_group_private_id
  vpc__private_subnet_1_id       = var.vpc__private_subnet_1_id
  vpc__private_subnet_2_id       = var.vpc__private_subnet_2_id
  vpc__private_subnet_3_id       = var.vpc__private_subnet_3_id


}