variable "domain" {}

module "certificates" {
  providers = {
    aws.us-east-1 = aws.us-east-1
  }
  source      = "../../modules/certificates"
  domain_name = "www.${var.domain}"
  subject_alternative_names = [
    var.domain,
  "api.${var.domain}"]
  zones = [
    var.domain,
    var.domain,
  var.domain]

}