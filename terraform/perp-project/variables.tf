variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "state_bucket" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}

}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for EC2"
  type        = string
}

variable "vpcproject_name" {
  description = "The name of the VPC project"
  type        = string
}

variable "environment" {
  description = "Environment name derived from tf workspace"
  type        = string
}