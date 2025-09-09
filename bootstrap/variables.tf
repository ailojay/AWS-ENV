variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  default     = "perp-project-tfstate"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locks"
  default     = "terraform-locks"
}
