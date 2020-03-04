variable "aws_region" {}
variable "aws_az_names" {
  type = list(string)
}

variable "env" {}
variable "organization" {}
variable "aws_linux_2_ami" {}

variable "alb__target_group_arn" {}

variable "iam__admin_key_name" {}
variable "vpc__security_group_private_id" {}
variable "vpc__private_subnet_1_id" {}
variable "vpc__private_subnet_2_id" {}
variable "vpc__private_subnet_3_id" {}