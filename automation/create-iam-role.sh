#!/bin/bash

# Script to create an IAM role with a trust policy and attach a managed policy

if [ -z "$1" ]; then
  echo "Usage: $0 <role-name>"
  exit 1
fi

ROLE_NAME=$1

# Basic trust policy for EC2
TRUST_POLICY='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

echo "Creating IAM role: $ROLE_NAME..."
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document "$TRUST_POLICY" \
  --description "EC2-assumable role with S3 read-only access"

echo "Attaching AmazonS3ReadOnlyAccess policy to $ROLE_NAME..."
aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

echo "✅ Role '$ROLE_NAME' created and policy attached."
