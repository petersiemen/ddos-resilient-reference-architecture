data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_api_gateway_rest_api" "any-api" {
  name        = "any-api"
  description = "A ddos resilient api (with the help of cloudfront and waf)"

  endpoint_configuration {
    types = [
    "REGIONAL"]
  }
}
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.any-api.id
  parent_id   = aws_api_gateway_rest_api.any-api.root_resource_id
  path_part   = "{proxy+}"

}

resource "aws_api_gateway_method" "method" {
  rest_api_id      = aws_api_gateway_rest_api.any-api.id
  resource_id      = aws_api_gateway_resource.resource.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda-proxy-integration" {
  rest_api_id = aws_api_gateway_rest_api.any-api.id
  resource_id = aws_api_gateway_method.method.resource_id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}


resource "aws_api_gateway_method" "root-method" {
  rest_api_id      = aws_api_gateway_rest_api.any-api.id
  resource_id      = aws_api_gateway_rest_api.any-api.root_resource_id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "root-lambda-proxy-integration" {
  rest_api_id = aws_api_gateway_rest_api.any-api.id
  resource_id = aws_api_gateway_method.root-method.resource_id
  http_method = aws_api_gateway_method.root-method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda-proxy-integration,
    aws_api_gateway_integration.root-lambda-proxy-integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.any-api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "lambda-permissions" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.any-api.execution_arn}/*/*"
}


resource "aws_api_gateway_usage_plan" "usage-plan" {
  name         = "my-usage-plan"
  description  = "my description"
  product_code = "MYCODE"

  api_stages {
    api_id = aws_api_gateway_rest_api.any-api.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }

  quota_settings {
    limit  = 1000
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}


resource "aws_api_gateway_api_key" "api-key" {
  name  = "my_api_key"
  value = var.api-key
}

resource "aws_api_gateway_usage_plan_key" "usage-plan-key" {
  key_id        = aws_api_gateway_api_key.api-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage-plan.id

}


resource "aws_cloudfront_distribution" "cf-for-api-gateway" {
  enabled    = true
  web_acl_id = var.web_acl_id

  aliases = [
  "api.${var.domain}"]

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

    target_origin_id = trimsuffix(trimprefix(aws_api_gateway_deployment.deployment.invoke_url, "https://"), "/prod")

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = [
      "Authorization"]

      query_string = true

      cookies {
        forward = "all"

      }
    }
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }


  origin {
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
      "TLSv1.2"]
    }
    custom_header {
      name  = "x-api-key"
      value = var.api-key
    }

    domain_name = trimsuffix(trimprefix(aws_api_gateway_deployment.deployment.invoke_url, "https://"), "/prod")
    origin_id   = trimsuffix(trimprefix(aws_api_gateway_deployment.deployment.invoke_url, "https://"), "/prod")
    origin_path = "/prod"
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
  name    = "api"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf-for-api-gateway.domain_name
    zone_id                = aws_cloudfront_distribution.cf-for-api-gateway.hosted_zone_id
    evaluate_target_health = false
  }
}
