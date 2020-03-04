resource "aws_key_pair" "admin-key" {
  key_name   = "${var.organization}-${var.env}-admin"
  public_key = var.admin_public_ssh_key
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.organization}-${var.env}-ec2-instance-profile"
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

resource "aws_iam_role_policy_attachment" "enable-cloud-watch-agent-on-ec2" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2-role.id
}

resource "aws_iam_role_policy_attachment" "enable-ssm-agent-on-ec2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2-role.id
}


resource "aws_iam_user" "developer" {
  name = var.developer_name
  path = "/"
}

resource "aws_iam_user_ssh_key" "developer" {
  username   = aws_iam_user.developer.name
  encoding   = "SSH"
  public_key = var.developer_ssh_key
  status     = "Active"
}


resource "aws_iam_role_policy_attachment" "read-only-app-config-for-ec2" {
  policy_arn = aws_iam_policy.app-config-read-only-policy.arn
  role       = aws_iam_role.ec2-role.id
}


resource "aws_iam_policy" "app-config-read-only-policy" {
  name        = "app-config-read-only-policy"
  description = "app-config-read-only-policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetDocument",
        "ssm:ListDocuments",
        "appconfig:ListApplications",
        "appconfig:GetApplication",
        "appconfig:ListEnvironments",
        "appconfig:GetEnvironment",
        "appconfig:ListConfigurationProfiles",
        "appconfig:GetConfigurationProfile",
        "appconfig:ListDeploymentStrategies",
        "appconfig:GetDeploymentStrategy",
        "appconfig:GetConfiguration",
        "appconfig:ListDeployments"

      ],
      "Resource": "*"
    }
  ]
}
EOF
}