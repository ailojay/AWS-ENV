#!/bin/bash

# Script to delete an IAM user and detach its policies

if [ -z "$1" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

USERNAME=$1

echo "Fetching attached policies for user '$USERNAME'..."
POLICIES=$(aws iam list-attached-user-policies --user-name "$USERNAME" --query 'AttachedPolicies[*].PolicyArn' --output text)

echo "Detaching policies..."
for policy in $POLICIES; do
  echo "Detaching $policy from $USERNAME"
  aws iam detach-user-policy --user-name "$USERNAME" --policy-arn "$policy"
done

echo "Deleting user '$USERNAME'..."
aws iam delete-user --user-name "$USERNAME"

echo "✅ User '$USERNAME' deleted."
