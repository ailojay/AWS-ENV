# Get information about your existing S3 bucket
data "aws_s3_bucket" "existing_assets" {
  bucket = "ade1000-assets"  # Your bucket name
}

# Get information about your existing IAM user
data "aws_iam_user" "s3_reader" {
  user_name = "s3-reader-user"
}