variable "ses_sender_email" {
  type        = string
  description = "Verified SES sender email"
}

variable "ses_recipient_email" {
  type        = string
  description = "Recipient email to receive inactive user alerts"
}
