variable "name" {
  description = "Name of the Config recorder and delivery channel"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for AWS Config"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for config snapshots"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
  default     = null
}

variable "record_all_supported" {
  description = "Whether to record all supported resource types"
  type        = bool
  default     = true
}

variable "include_global_resources" {
  description = "Whether to include global resource types"
  type        = bool
  default     = true
}

variable "enable_recording" {
  description = "Whether to enable configuration recording"
  type        = bool
  default     = true
}