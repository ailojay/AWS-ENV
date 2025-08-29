resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.policy

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}