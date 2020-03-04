resource "aws_s3_bucket" "lambda-functions" {
  bucket        = var.lambda_functions_bucket
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

