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


data "template_file" "user_data" {
  template = base64encode(file("${path.module}/user-data.sh"))
}

resource "aws_launch_template" "launch-template" {
  name_prefix   = "${var.organization}-${var.env}-webserver"
  image_id      = var.aws_linux_2_ami
  instance_type = "t2.micro"

  key_name  = data.terraform_remote_state.iam.outputs.admin_key__name
  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [
  data.terraform_remote_state.vpc.outputs.security_group_private_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.organization}-${var.env}-webserver"
      Environment = var.env
    }
  }


}


resource "aws_autoscaling_group" "asg" {
  availability_zones = [
  var.aws_az_a]
  desired_capacity = 1
  max_size         = 5
  min_size         = 1

  target_group_arns = [
  var.alb_target_group_arn]

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

resource "aws_autoscaling_policy" "simple" {
  name                   = "${var.organization}-${var.env}-simple-scaling"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}


resource "aws_autoscaling_policy" "target-tracking" {
  name                   = "${var.organization}-${var.env}-target-tracking-scaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}


resource "aws_autoscaling_policy" "policy" {
  name                   = "${var.organization}-${var.env}-step-scaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "StepScaling"

  metric_aggregation_type   = "Average"
  estimated_instance_warmup = 180

  adjustment_type = "PercentChangeInCapacity"

  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
  }
  step_adjustment {
    scaling_adjustment          = 10
    metric_interval_lower_bound = 10
    metric_interval_upper_bound = 20
  }
  step_adjustment {
    scaling_adjustment          = 30
    metric_interval_lower_bound = 20
    metric_interval_upper_bound = null
  }

  step_adjustment {
    scaling_adjustment          = 0
    metric_interval_lower_bound = -10
    metric_interval_upper_bound = 0
  }
  step_adjustment {
    scaling_adjustment          = -10
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = -10
  }
  step_adjustment {
    scaling_adjustment          = -30
    metric_interval_lower_bound = null
    metric_interval_upper_bound = -20
  }
}


resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "AverageCPUUtilizationOfASGGroup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 50

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [
    aws_autoscaling_policy.simple.arn,
  aws_autoscaling_policy.policy.arn]
}


resource "aws_placement_group" "placement-group" {
  name     = "${var.organization}-${var.env}-webserver"
  strategy = "spread"
}