output "recorder_arn" {
  description = "ARN of the primary AWS Config recorder (aws_config_configuration_recorder.this)"
  value       = aws_config_configuration_recorder.this.arn
}

output "recorder_name" {
  description = "The name of the AWS Config recorder resource created in this module, useful for referencing in larger infrastructures."
  value       = aws_config_configuration_recorder.this.name
}