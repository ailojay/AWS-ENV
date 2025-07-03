#!/bin/bash

# Set variables
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="cloudtrail-logs-$ACCOUNT_ID"
REGION="us-east-1"

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Enable server-side encryption with AES256
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# OPTIONAL: Add lifecycle policy (uncomment if needed)
# aws s3api put-bucket-lifecycle-configuration \
#   --bucket $BUCKET_NAME \
#   --lifecycle-configuration '{
#     "Rules": [{
#       "ID": "ArchiveOldLogs",
#       "Prefix": "AWSLogs/",
#       "Status": "Enabled",
#       "Transitions": [{
#         "Days": 30,
#         "StorageClass": "GLACIER"
#       }]
#     }]
#   }'

echo "✅ S3 bucket '$BUCKET_NAME' is now hardened for secure CloudTrail log storage."
