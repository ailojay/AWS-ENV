resource "aws_s3_bucket" "audit_bucket" {
  bucket = "iam-key-audit-logs-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "IAM Key Audit Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "audit_block" {
  bucket = aws_s3_bucket.audit_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_encryption" {
  bucket = aws_s3_bucket.audit_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
