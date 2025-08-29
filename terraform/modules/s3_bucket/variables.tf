variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access to the bucket"
  type        = bool
  default     = true
}