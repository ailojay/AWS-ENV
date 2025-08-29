variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}
variable "environment" {
  description = "The environment (e.g., prod, dev)"
  type        = string
  default     = "dev"
}
variable "enable_versioning" {
  description = "Whether to enable versioning"
  type        = bool
  default     = true
}
variable "block_public_access" {
  description = "Whether to block public access"
  type        = bool
  default     = true
}