data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_cloudfront_distribution" "cf-for-dynamic-content" {
  enabled = true

  web_acl_id = var.web_acl_id

  aliases = [
    "www.${var.domain}",
  var.domain]

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
    "PUT"]
    cached_methods = [
      "GET",
    "HEAD"]

    target_origin_id = var.alb_id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
      "*"]
      query_string = false
      cookies {
        forward = "all"
      }
    }
  }
  origin {
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = [
      "TLSv1.1"]
    }
    domain_name = var.alb_dns_name
    origin_id   = var.alb_id
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = var.acm_certification_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "apex" {

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf-for-dynamic-content.domain_name
    zone_id                = aws_cloudfront_distribution.cf-for-dynamic-content.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {

  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf-for-dynamic-content.domain_name
    zone_id                = aws_cloudfront_distribution.cf-for-dynamic-content.hosted_zone_id
    evaluate_target_health = false
  }
}