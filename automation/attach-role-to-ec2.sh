#!/bin/bash

# Variables
ROLE_NAME="EC2S3ReadOnlyRole"
POLICY_ARN="arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
INSTANCE_ID="i-0bfbe6732beb05300"  # Replace with your current EC2 instance ID
PROFILE_NAME="EC2InstanceProfile"

# Step 1: Create Trust Policy File
cat > trust-policy.json <<EOF
{
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
}
EOF

# Step 2: Create the IAM Role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust-policy.json

# Step 3: Attach Policy to the Role
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $POLICY_ARN

# Step 4: Create Instance Profile
aws iam create-instance-profile --instance-profile-name $PROFILE_NAME

# Step 5: Add the Role to the Instance Profile
aws iam add-role-to-instance-profile --instance-profile-name $PROFILE_NAME --role-name $ROLE_NAME

# Wait for the instance profile to propagate (important!)
echo "Waiting 20 seconds for instance profile propagation..."
sleep 20

# Step 6: Attach Instance Profile to EC2 Instance
aws ec2 associate-iam-instance-profile \
  --instance-id $INSTANCE_ID \
  --iam-instance-profile Name=$PROFILE_NAME

echo "✅ IAM Role attached to EC2 instance successfully."
