variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ses_email_source" {
  description = "Source email for SES notifications"
  type        = string
}

variable "ses_email_recipient" {
  description = "Recipient email for SES notifications"
  type        = string
}

variable "s3_bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "crypto-sec-findings"
}