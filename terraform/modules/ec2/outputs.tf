output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
  sensitive   = false
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
  sensitive   = false
}