terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "secure_data" {
  bucket = "secure-data-961535847135-policy"
  tags = {
    Compliance   = "CIS-3.3"
    ISO27001     = "A.12"
    Environment  = "Production"
  }
}

resource "aws_s3_bucket_ownership_controls" "secure_data_ownership" {
  bucket = aws_s3_bucket.secure_data.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "secure_data_versioning" {
  bucket = aws_s3_bucket.secure_data.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_data_encryption" {
  bucket = aws_s3_bucket.secure_data.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "alias/s3-encryption-key"
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "secure_data_public_access" {
  bucket = aws_s3_bucket.secure_data.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}