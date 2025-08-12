#!/bin/bash

# Set variables
TRAIL_NAME="OrgTrail"
BUCKET_NAME="cloudtrail-logs-$(aws sts get-caller-identity --query Account --output text)"
REGION="us-east-1"

# Create the trail
aws cloudtrail create-trail \
  --name $TRAIL_NAME \
  --s3-bucket-name $BUCKET_NAME \
  --is-multi-region-trail \
  --enable-log-file-validation \
  --output text

# Start logging
aws cloudtrail start-logging --name $TRAIL_NAME

echo "✅ CloudTrail trail '$TRAIL_NAME' created, started, and logging to bucket '$BUCKET_NAME'."
