#!/bin/bash

TOPIC_ARN="arn:aws:sns:us-east-1:961535847135:iam-mfa-alerts"

# Fetch all IAM users
users=$(aws iam list-users --query 'Users[].UserName' --output text)

for user in $users; do
  # Count MFA devices for the user
  mfa_count=$(aws iam list-mfa-devices --user-name "$user" --query 'MFADevices | length(@)')

  if [ "$mfa_count" -eq 0 ]; then
    echo "User $user DOES NOT have MFA enabled."

    MESSAGE="Alert: IAM user $user does NOT have MFA enabled."

    echo "Publishing to SNS Topic ARN: $TOPIC_ARN"
    echo "Message: $MESSAGE"

    aws sns publish --topic-arn "$TOPIC_ARN" --message "$MESSAGE" --subject "IAM MFA Alert: $user"
  else
    echo "User $user has MFA enabled."
  fi
done
# End of script