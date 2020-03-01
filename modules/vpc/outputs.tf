output "vpc_id" {
  value = aws_vpc.this.id
}


output "public_subnet_1_id" {
  value = aws_subnet.public-1.id
}

output "public_subnet_1_arn" {
  value = aws_subnet.public-1.arn
}

output "public_subnet_2_id" {
  value = aws_subnet.public-2.id
}

output "public_subnet_2_arn" {
  value = aws_subnet.public-2.arn
}

output "public_subnet_3_id" {
  value = aws_subnet.public-3.id
}

output "public_subnet_3_arn" {
  value = aws_subnet.public-3.arn
}


output "private_subnet_1_id" {
  value = aws_subnet.private-1.id
}

output "private_subnet_1_arn" {
  value = aws_subnet.private-1.arn
}

output "private_subnet_2_id" {
  value = aws_subnet.private-2.id
}

output "private_subnet_2_arn" {
  value = aws_subnet.private-2.arn
}

output "private_subnet_3_id" {
  value = aws_subnet.private-3.id
}

output "private_subnet_3_arn" {
  value = aws_subnet.private-3.arn
}

output "security_group_private_id" {
  value = aws_security_group.private.id
}

output "security_group_dmz_id" {
  value = aws_security_group.dmz.id
}

output "security_group_lb_id" {
  value = aws_security_group.lb.id
}

output "security_group_cloudfront_g_http" {
  value = aws_security_group.cloudfront-global-http.id
}

output "security_group_cloudfront_r_http" {
  value = aws_security_group.cloudfront-regional-http.id
}
