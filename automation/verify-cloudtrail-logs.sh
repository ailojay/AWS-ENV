#!/bin/bash

TRAIL_NAME="OrgTrail"
BUCKET_NAME="cloudtrail-logs-$(aws sts get-caller-identity --query Account --output text)"
REGION="us-east-1"

echo "🔍 Checking recent events for trail: $TRAIL_NAME"

# Look for the last 5 logged events
aws cloudtrail lookup-events \
  --max-results 5 \
  --output table

# Check if logs exist in S3
echo -e "\n📦 Checking S3 bucket for log files:"
aws s3 ls s3://$BUCKET_NAME/AWSLogs/ --recursive --human-readable --summarize
