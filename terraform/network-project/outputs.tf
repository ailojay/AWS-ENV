output "vpc_id" {
  value = module.main_vpc.vpc_id
}

output "subnet_ids" {
  value = module.main_vpc.public_subnet_ids
}

output "s3_bucket_arn" {
  value = data.aws_s3_bucket.existing_assets.arn
}

output "iam_user_arn" {
  value = data.aws_iam_user.s3_reader.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.web_alb.alb_dns_name
}