resource "aws_s3_bucket" "lambda-functions" {
  bucket = var.lambda_functions_bucket
  acl    = "private"

  versioning {
    enabled = true
  }
}

