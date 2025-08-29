output "trail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = aws_cloudtrail.this.arn
}

output "home_region" {
  description = "Home region of the CloudTrail trail"
  value       = aws_cloudtrail.this.home_region
}