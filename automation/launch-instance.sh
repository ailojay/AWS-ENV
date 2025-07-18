#!/bin/bash

# Configuration
KEY_NAME="tester"
INSTANCE_TYPE="t2.micro"
TAG_NAME="AutomatedInstance"
SECURITY_GROUP="default"  # Replace with your security group ID

# Get the latest Amazon Linux 2023 AMI for your region
AMI_ID=$(aws ssm get-parameters \
  --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query 'Parameters[0].Value' \
  --output text)

# Launch the instance
echo "Launching EC2 instance with key pair: $KEY_NAME"
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

# Check if launch succeeded
if [ -z "$INSTANCE_ID" ]; then
  echo "Error: Failed to launch instance"
  exit 1
fi

echo "Instance $INSTANCE_ID is launching..."

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Instance ready! Connect using:"
echo "ssh -i ~/.ssh/$KEY_NAME.pem ec2-user@$PUBLIC_IP"

# Optional: Add to known hosts
echo "$PUBLIC_IP ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBB..." >> ~/.ssh/known_hosts