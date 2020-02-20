data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "iam.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "vpc.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-lock"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}


resource "aws_instance" "ec2-test" {
  ami           = var.aws_linux_2_ami
  instance_type = "t2.micro"
  key_name      = data.terraform_remote_state.iam.outputs.admin_key__name

  iam_instance_profile = data.terraform_remote_state.iam.outputs.aws_iam_instance_profile__ec2__name

  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet_1_id

  vpc_security_group_ids = [
    data.terraform_remote_state.vpc.outputs.security_group_private_id
  ]


  tags = {
    Name        = "webserver"
    Hostname    = "webserver"
    Role        = "webserver"
    Environment = var.env
  }

  user_data = data.template_file.user_data.rendered
}
