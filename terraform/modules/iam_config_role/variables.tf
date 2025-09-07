variable "role_name" {
  description = "Name of the IAM role for AWS Config"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Config logs"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}