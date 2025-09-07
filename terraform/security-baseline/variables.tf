# KMS Variables
variable "kms_key_name" {
  description = "Name for the KMS key"
  type        = string
  default     = "security-baseline-key"
}

variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "Encryption key for security baseline resources"
}

# CloudTrail Variables
variable "cloudtrail_name" {
  description = "Name for the CloudTrail trail"
  type        = string
  default     = "security-baseline-trail"
}

variable "cloudtrail_s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

# GuardDuty Variables
variable "enable_guardduty" {
  description = "Whether to enable GuardDuty"
  type        = bool
  default     = true
}

# Config Variables
variable "config_name" {
  description = "Name for AWS Config"
  type        = string
  default     = "security-baseline-config"
}

variable "config_s3_bucket_name" {
  description = "S3 bucket name for Config logs"
  type        = string
}

# General Variables
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Project     = "security-baseline"
    Environment = "learning"
    ManagedBy   = "terraform"
  }
}