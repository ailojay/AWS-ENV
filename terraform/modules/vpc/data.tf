# Get the current region
data "aws_region" "current" {}

# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the S3 bucket if a name is provided
data "aws_s3_bucket" "assets" {
  count = var.s3_bucket_name != "" ? 1 : 0
  bucket = var.s3_bucket_name
}