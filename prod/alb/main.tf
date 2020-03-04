variable "vpc__vpc_id" {}
variable "vpc__security_group_lb_id" {}
variable "vpc__security_group_cloudfront_g_http" {}
variable "vpc__security_group_cloudfront_r_http" {}
variable "vpc__public_subnet_1_id" {}
variable "vpc__public_subnet_2_id" {}
variable "vpc__public_subnet_3_id" {}

module "alb" {
  source          = "../../modules/alb"
  env             = var.env
  organization    = var.organization
  aws_region      = var.aws_region
  tf_state_bucket = var.tf_state_bucket

  vpc__vpc_id                           = var.vpc__vpc_id
  vpc__security_group_lb_id             = var.vpc__security_group_lb_id
  vpc__security_group_cloudfront_g_http = var.vpc__security_group_cloudfront_g_http
  vpc__security_group_cloudfront_r_http = var.vpc__security_group_cloudfront_r_http

  vpc__public_subnet_1_id = var.vpc__public_subnet_1_id
  vpc__public_subnet_2_id = var.vpc__public_subnet_2_id
  vpc__public_subnet_3_id = var.vpc__public_subnet_3_id

}