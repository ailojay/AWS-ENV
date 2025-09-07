#!/bin/bash

# Script to delete an IAM role and detach its policies

if [ -z "$1" ]; then
  echo "Usage: $0 <role-name>"
  exit 1
fi

ROLE_NAME=$1

echo "Fetching attached policies for role '$ROLE_NAME'..."
POLICIES=$(aws iam list-attached-role-policies --role-name "$ROLE_NAME" --query 'AttachedPolicies[*].PolicyArn' --output text)

echo "Detaching policies..."
for policy in $POLICIES; do
  echo "Detaching $policy from $ROLE_NAME"
  aws iam detach-role-policy --role-name "$ROLE_NAME" --policy-arn "$policy"
done

echo "Deleting role '$ROLE_NAME'..."
aws iam delete-role --role-name "$ROLE_NAME"

echo "✅ Role '$ROLE_NAME' deleted."
