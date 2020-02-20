resource "aws_s3_bucket" "terraform-state" {
  bucket = var.tf-state-bucket
  acl    = "private"

  versioning {
    enabled = true
  }

}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "terraform-lock"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}
