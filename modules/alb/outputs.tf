output "target_group_arn" {
  value = aws_alb_target_group.target-group.arn
}

output "alb_id" {
  value = aws_alb.alb.id
}

output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}
