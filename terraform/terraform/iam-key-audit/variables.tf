variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ses_sender_email" {
  description = "The verified SES sender email address"
  type        = string
}

variable "ses_recipient_email" {
  description = "The verified SES recipient email address"
  type        = string
}

