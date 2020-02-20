output "admin_key__name" {
  value = aws_key_pair.admin-key.key_name
}


output "aws_iam_instance_profile__ec2__name" {
  value = aws_iam_instance_profile.ec2.name
}