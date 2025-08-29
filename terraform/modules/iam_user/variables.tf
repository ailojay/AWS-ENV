variable "username" {
  description = "Name of the IAM user"
  type        = string
}

variable "create_iam_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "create_access_key" {
  description = "Whether to create an access key"
  type        = bool
  default     = false
}

variable "path" {
  description = "Path for the IAM user"
  type        = string
  default     = "/"
}

variable "custom_policies" {
  description = "List of custom policy ARNs to attach"
  type        = list(string)
  default     = []
}