output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.this.id
}

output "arn" {
  description = "ARN of the GuardDuty detector"
  value       = aws_guardduty_detector.this.arn
}