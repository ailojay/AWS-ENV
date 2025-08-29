variable "name" {
  description = "Instance name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID" 
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}