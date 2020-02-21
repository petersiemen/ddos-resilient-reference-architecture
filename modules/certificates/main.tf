resource "aws_acm_certificate" "main_cert" {

  domain_name       = "${var.organization}.com"
  validation_method = "DNS"

  subject_alternative_names = [
  "www.${var.organization}.com"]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "main_cert_main_validation" {
  count = 1

  name = "${lookup(aws_acm_certificate.main_cert.domain_validation_options[count.index], "resource_record_name")}"

  type    = "${lookup(aws_acm_certificate.main_cert.domain_validation_options[count.index], "resource_record_type")}"
  zone_id = var.zone_id
  records = [
  "${lookup(aws_acm_certificate.main_cert.domain_validation_options[count.index], "resource_record_value")}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.main_cert.arn

  validation_record_fqdns = [
    aws_route53_record.main_cert_main_validation.fqdn
  ]
}