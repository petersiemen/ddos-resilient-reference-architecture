resource "aws_cloudfront_distribution" "cf-for-dynamic-content" {
  enabled = true

  web_acl_id = var.web_acl_id

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

    viewer_protocol_policy = "allow-all"
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
    cloudfront_default_certificate = true
  }
}