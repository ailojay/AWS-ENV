output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "key_name" {
  description = "SSH key name used for the instance"
  value       = aws_instance.this.key_name
}

output "iam_instance_profile" {
  description = "IAM instance profile attached to the instance"
  value       = aws_instance.this.iam_instance_profile
}

output "ami_id" {
  description = "AMI ID used for the instance"
  value       = aws_instance.this.ami
}