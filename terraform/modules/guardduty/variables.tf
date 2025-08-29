variable "enable" {
  description = "Whether to enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_s3_protection" {
  description = "Whether to enable S3 protection"
  type        = bool
  default     = true
}

variable "enable_kubernetes_protection" {
  description = "Whether to enable Kubernetes protection"
  type        = bool
  default     = false
}

variable "enable_malware_protection" {
  description = "Whether to enable malware protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to GuardDuty detector"
  type        = map(string)
  default     = {}
}