variable "notification_email" {
  description = "Email address for SNS alerts"
  type        = string
}

variable "log_bucket_name" {
  description = "The name of the existing S3 bucket to store remediation logs"
  type        = string
}
