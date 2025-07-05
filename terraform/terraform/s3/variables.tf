variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}

variable "bucket_name" {
  description = "A globally unique S3 bucket name"
  type        = string
}

variable "aws_account_id" {
  description = "Your AWS Account ID"
  type        = string
}
