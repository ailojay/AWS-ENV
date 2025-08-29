variable "name" {
  description = "Name prefix for KMS key and alias"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "Terraform-managed KMS key"
}

variable "deletion_window_days" {
  description = "Duration in days before key is deleted"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Whether to enable automatic key rotation"
  type        = bool
  default     = true
}

variable "policy" {
  description = "Custom KMS policy document"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to KMS key"
  type        = map(string)
  default     = {}
}