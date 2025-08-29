output "username" {
  description = "IAM user name"
  value       = var.create_iam_user ? aws_iam_user.this[0].name : var.username
}

output "access_key_id" {
  description = "Access key ID (only if created)"
  value       = var.create_access_key ? aws_iam_access_key.this[0].id : null
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret access key (only if created)"
  value       = var.create_access_key ? aws_iam_access_key.this[0].secret : null
  sensitive   = true
}