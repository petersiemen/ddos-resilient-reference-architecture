variable "aws_region" {}
variable "env" {}
variable "organization" {}
variable "tf_state_bucket" {}

variable "vpc__vpc_id" {}
variable "vpc__security_group_lb_id" {}
variable "vpc__security_group_cloudfront_g_http" {}
variable "vpc__security_group_cloudfront_r_http" {}
variable "vpc__public_subnet_1_id" {}
variable "vpc__public_subnet_2_id" {}
variable "vpc__public_subnet_3_id" {}