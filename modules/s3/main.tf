resource "aws_s3_bucket" "terraform-state" {
  bucket = var.lambda_functions_bucket
  acl    = "private"

  versioning {
    enabled = true
  }
}


