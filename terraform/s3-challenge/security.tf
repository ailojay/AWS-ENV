resource "aws_s3_bucket" "ade091" {
  bucket = "ade091-bucket"
}

resource "aws_s3_bucket_public_access_block" "ade091_block" {
  bucket                  = aws_s3_bucket.ade091.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ade091_encryption" {
  bucket = aws_s3_bucket.ade091.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
