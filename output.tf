output vpc_id {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output nat_public_ips {
  description = "nat public ips"
  value       = aws_eip.nat.*.public_ip
}

output public_subnets {
  description = "public subnets"
  value       = module.vpc.public_subnets
}

output private_subnets {
  description = "private subnets"
  value       = module.vpc.private_subnets
}

output private_zone_id {
  description = "private zone id"
  value       = aws_route53_zone.private.zone_id
}

output default_security_group_id {
  description = "default security group id"
  value       = module.vpc.default_security_group_id
}



