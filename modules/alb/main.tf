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


resource "aws_alb_target_group" "target-group" {
  name     = "${var.organization}-${var.env}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    enabled             = true
    interval            = 5
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/index.html"
    port                = 80
    timeout             = 2
    unhealthy_threshold = 2
  }
}


//resource "aws_alb_target_group_attachment" "webserver" {
//  target_group_arn = aws_alb_target_group.target-group.arn
//  target_id        = data.terraform_remote_state.web-server.outputs.web_server_instance_id
//  port             = 80
//}

//resource "aws_autoscaling_attachment" "asg_attachment_bar" {
//  autoscaling_group_name = data.terraform_remote_state.asg-webserver.outputs.asg_group_name
//  alb_target_group_arn   = aws_alb_target_group.target-group.arn
//}


resource "aws_lb" "alb" {
  name               = "${var.organization}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
  data.terraform_remote_state.vpc.outputs.security_group_lb_id]
  subnets = [
    data.terraform_remote_state.vpc.outputs.public_subnet_1_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_2_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_3_id,
  ]

  tags = {
    Name        = "${var.organization}-${var.env}-alb"
    Environment = var.env
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target-group.arn
  }
}