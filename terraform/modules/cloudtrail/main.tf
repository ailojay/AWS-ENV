resource "aws_cloudtrail" "this" {
  name                          = var.name
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = var.include_global_events
  enable_logging                = var.enable_logging
  is_multi_region_trail         = var.multi_region
  enable_log_file_validation    = var.enable_log_file_validation

  dynamic "event_selector" {
    for_each = var.event_selectors
    content {
      read_write_type           = event_selector.value.read_write_type
      include_management_events = event_selector.value.include_management_events
    }
  }

  tags = var.tags
}