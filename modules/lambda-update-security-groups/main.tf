provider "aws" {
  alias = "us-east-1"
}

resource "aws_lambda_function" "lambda-update-security-groups" {
  function_name = "UpdateSecurityGroups"

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  handler = var.handler
  runtime = "python3.7"

  role = aws_iam_role.lambda-exec.arn
}


resource "aws_iam_role" "lambda-exec" {
  name = "lambda-update-security-groups"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "lambda.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF
}


resource "aws_iam_policy" "update-security-groups-policy" {
  name        = "update-security-groups-policy"
  description = "update-security-groups-policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:security-group/*"
        },
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeSecurityGroups",
            "Resource": "*"
        },
        {
            "Action": [
                "logs:CreateLogGroup",
                 "logs:CreateLogStream",
                 "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-update-security-groups" {
  policy_arn = aws_iam_policy.update-security-groups-policy.arn
  role       = aws_iam_role.lambda-exec.id
}


resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  provider  = aws.us-east-1
  topic_arn = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda-update-security-groups.arn
}