data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    encrypt        = "true"
    bucket         = var.tf_state_bucket
    key            = "alb.tfstate"
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
  template = base64encode(file("${path.module}/user-data.sh"))
}

resource "aws_launch_template" "launch-template" {
  name_prefix   = "${var.organization}-${var.env}-webserver"
  image_id      = var.aws_linux_2_ami
  instance_type = "t2.micro"

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [
  data.terraform_remote_state.vpc.outputs.security_group_private_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.organization}-${var.env}-webserver"
    }
  }
}


resource "aws_autoscaling_group" "asg" {
  availability_zones = [
  var.aws_az_a]
  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  target_group_arns = [
  data.terraform_remote_state.alb.outputs.target_group_arn]

  vpc_zone_identifier = [
    data.terraform_remote_state.vpc.outputs.private_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.private_subnet_2_id,
  data.terraform_remote_state.vpc.outputs.private_subnet_3_id]


  launch_template {
    id = aws_launch_template.launch-template.id
    # If not using the latest launch template this will make you wonder why updates of your launch template will not be picked up
    version = "$Latest"
  }
}
