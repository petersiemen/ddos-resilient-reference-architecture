resource "aws_alb_target_group" "target-group" {
  name     = "${var.organization}-${var.env}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc__vpc_id

  health_check {
    enabled             = true
    interval            = 5
    healthy_threshold   = 2
    protocol            = "HTTP"
    path                = "/"
    port                = 80
    timeout             = 2
    unhealthy_threshold = 2
  }
}


resource "aws_alb" "alb" {
  name                             = "${var.organization}-${var.env}-alb"
  internal                         = false
  load_balancer_type               = "application"
  enable_http2                     = true
  enable_cross_zone_load_balancing = true
  security_groups = [
    var.vpc__security_group_lb_id,
    var.vpc__security_group_cloudfront_g_http,
    var.vpc__security_group_cloudfront_r_http
  ]
  subnets = [
    var.vpc__public_subnet_1_id,
    var.vpc__public_subnet_2_id,
    var.vpc__public_subnet_3_id
  ]

  tags = {
    Name        = "${var.organization}-${var.env}-alb"
    Environment = var.env
  }

}


resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target-group.arn
  }
}


