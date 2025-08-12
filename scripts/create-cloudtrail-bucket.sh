#!/bin/bash

# Set bucket name and region
BUCKET_NAME="cloudtrail-logs-$(aws sts get-caller-identity --query Account --output text)"
REGION="us-east-1"

# Create the S3 bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION

# Block public access (required for CloudTrail)
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "✅ S3 bucket '$BUCKET_NAME' created and secured."
