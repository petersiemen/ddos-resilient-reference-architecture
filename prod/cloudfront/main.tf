variable "alb__dns_name" {}
variable "alb__id" {}
variable "waf__web_acl_id" {}
variable "certificates__acm_certification_arn" {}

module "cloudfront" {
  source       = "../../modules/cloudfront"
  env          = var.env
  organization = var.organization
  aws_region   = var.aws_region
  domain       = var.domain

  alb__dns_name                       = var.alb__dns_name
  alb__id                             = var.alb__id
  waf__web_acl_id                     = var.waf__web_acl_id
  certificates__acm_certification_arn = var.certificates__acm_certification_arn
}