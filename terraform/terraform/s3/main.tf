provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "DenyPublicRead"
        Effect = "Deny"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid = "AllowAccountAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:root"
        }
        Action = "s3:*"
Principal = {
  AWS = "arn:aws:iam::${var.aws_account_id}:root"
}
        Resource = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ]
      }
    ]
  })
}
