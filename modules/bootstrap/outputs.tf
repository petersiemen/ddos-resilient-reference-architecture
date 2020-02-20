output "bucket" {
  value = aws_s3_bucket.terraform-state.bucket
}

output "lock_name" {
  value = aws_dynamodb_table.terraform-lock.name
}
