variable "env" {}
variable "organization" {}
variable "aws_region" {}
variable "aws_linux_2_ami" {}

variable "iam__admin_key_name" {}
variable "iam__aws_iam_instance_profile_ec2_name" {}
variable "vpc__public_subnet_1_id" {}
variable "vpc__security_group_dmz_id" {}

module "jumphost" {
  source          = "../../modules/jumphost"
  env             = var.env
  organization    = var.organization
  aws_linux_2_ami = var.aws_linux_2_ami
  aws_region      = var.aws_region

  iam__admin_key_name                    = var.iam__admin_key_name
  iam__aws_iam_instance_profile_ec2_name = var.iam__aws_iam_instance_profile_ec2_name
  vpc__public_subnet_1_id                = var.vpc__public_subnet_1_id
  vpc__security_group_dmz_id             = var.vpc__security_group_dmz_id

}