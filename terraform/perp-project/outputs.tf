output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}

output "vpc_id" {
  value = module.main_vpc.vpc_id
}

output "security_group_id" {
  value = module.main_vpc.security_group_id
}