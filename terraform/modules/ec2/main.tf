resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.ssh_key_name
  iam_instance_profile   = var.iam_instance_profile
  monitoring             = var.monitoring_enabled
  disable_api_termination = var.disable_api_termination
  user_data              = var.user_data

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}