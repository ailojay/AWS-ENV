#!/bin/bash

echo "🔍 Starting IAM Audit..."

# List all users
aws iam list-users --query 'Users[*].UserName' --output text

# For each user, check key usage, attached policies, and MFA
for user in $(aws iam list-users --query 'Users[*].UserName' --output text); do
  echo -e "\n===== 🔐 Auditing user: $user ====="

  echo "🔑 Access Keys:"
  aws iam list-access-keys --user-name "$user" --output table

  echo "🛡️  Attached Policies:"
  aws iam list-attached-user-policies --user-name "$user" --output table

  echo "📛 Inline Policies:"
  aws iam list-user-policies --user-name "$user" --output table

  echo "✅ MFA Devices:"
  aws iam list-mfa-devices --user-name "$user" --output table
done

echo -e "\n✅ IAM audit completed."
