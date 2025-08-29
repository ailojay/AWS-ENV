variable "name" {
  description = "Name of the CloudTrail trail"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "include_global_events" {
  description = "Whether to include global service events"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Whether to enable logging"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Whether the trail is multi-region"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Whether to enable log file validation"
  type        = bool
  default     = true
}

variable "event_selectors" {
  description = "List of event selectors for the trail"
  type = list(object({
    read_write_type           = string
    include_management_events = bool
  }))
  default = [{
    read_write_type           = "All"
    include_management_events = true
  }]
}

variable "tags" {
  description = "Tags to apply to CloudTrail"
  type        = map(string)
  default     = {}
}