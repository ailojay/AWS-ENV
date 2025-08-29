provider "aws" {
  region = "us-east-1"
}

# Get your account ID for policies
data "aws_caller_identity" "current" {}

# Enable all security services
module "guardduty" {
  source = "../modules/guardduty"
}

module "kms" {
  source = "../modules/kms"
  name   = "security-baseline-key"
}

module "cloudtrail" {
  source          = "../modules/cloudtrail"
  name            = "security-trail"
  s3_bucket_name  = "your-existing-log-bucket" # Use your S3 bucket
}

# Note: AWS Config needs an IAM role first