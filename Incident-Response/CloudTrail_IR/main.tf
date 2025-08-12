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

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "ir-cloudtrail-log-007"
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail_logs_ownership" {
  bucket = aws_s3_bucket.cloudtrail_logs.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs_versioning" {
  bucket = aws_s3_bucket.cloudtrail_logs.bucket
  versioning_configuration {
    status = "Enabled"
  }
}