output "admin_key_name" {
  value = aws_key_pair.admin-key.key_name
}


output "aws_iam_instance_profile_ec2_name" {
  value = aws_iam_instance_profile.ec2.name
}