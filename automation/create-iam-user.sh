#!/bin/bash

# Script to create an IAM user and attach a basic policy

if [ -z "$1" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

USERNAME=$1

echo "Creating IAM user: $USERNAME..."
aws iam create-user --user-name "$USERNAME"

echo "Attaching AmazonEC2ReadOnlyAccess policy to $USERNAME..."
aws iam attach-user-policy \
    --user-name "$USERNAME" \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess

echo "✅ User '$USERNAME' created and policy attached."
