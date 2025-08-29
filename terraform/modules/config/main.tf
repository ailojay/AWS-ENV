resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = var.role_arn

  recording_group {
    all_supported                 = var.record_all_supported
    include_global_resource_types = var.include_global_resources
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.name
  s3_bucket_name = var.s3_bucket_name
  sns_topic_arn  = var.sns_topic_arn

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.enable_recording

  depends_on = [aws_config_delivery_channel.this]
}