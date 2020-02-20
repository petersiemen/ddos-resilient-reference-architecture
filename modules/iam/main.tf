resource "aws_key_pair" "admin-key" {
  key_name   = "${var.organization}-${var.env}-admin"
  public_key = var.admin_public_ssh_key
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.organization}-${var.env}-ec2-profile"
  path = "/terraform/"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role" "ec2-role" {
  name = "${var.organization}-${var.env}-ec2-role"
  path = "/terraform/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}