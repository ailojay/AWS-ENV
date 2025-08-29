output "s3_reader_credentials" {
  description = "S3 reader user credentials"
  value       = {
    access_key_id     = module.s3_reader_user.access_key_id
    secret_access_key = module.s3_reader_user.secret_access_key
  }
  sensitive = true
}

output "backup_username" {
  description = "Backup user name"
  value       = module.backup_user.username
}