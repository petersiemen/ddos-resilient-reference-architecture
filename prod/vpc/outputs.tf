output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  value = module.vpc.public_subnet_1_id
}

output "public_subnet_1_arn" {
  value = module.vpc.public_subnet_1_arn
}

output "public_subnet_2_id" {
  value = module.vpc.public_subnet_2_id
}

output "public_subnet_2_arn" {
  value = module.vpc.public_subnet_2_arn
}

output "public_subnet_3_id" {
  value = module.vpc.public_subnet_3_id
}

output "public_subnet_3_arn" {
  value = module.vpc.public_subnet_3_arn
}


output "private_subnet_1_id" {
  value = module.vpc.private_subnet_1_id
}

output "private_subnet_1_arn" {
  value = module.vpc.private_subnet_1_arn
}

output "private_subnet_2_id" {
  value = module.vpc.private_subnet_2_id
}

output "private_subnet_2_arn" {
  value = module.vpc.private_subnet_2_arn
}

output "private_subnet_3_id" {
  value = module.vpc.private_subnet_3_id
}

output "private_subnet_3_arn" {
  value = module.vpc.private_subnet_3_arn
}

output "security_group_private_id" {
  value = module.vpc.security_group_private_id
}

output "security_group_dmz_id" {
  value = module.vpc.security_group_dmz_id
}

output "security_group_lb_id" {
  value = module.vpc.security_group_lb_id
}
