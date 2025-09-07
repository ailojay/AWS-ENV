variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance into"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

variable "instance_name" {
  type        = string
  description = "Custom instance name"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to the instance"
  type        = string
  default     = null
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Protect against accidental termination"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of root volume"
  type        = string
  default     = "gp2"
}

variable "root_volume_encrypted" {
  description = "Encrypt root volume"
  type        = bool
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the instance will be deployed"
}

variable "name" {
  type        = string
  description = "Name of the EC2 instance"
}
