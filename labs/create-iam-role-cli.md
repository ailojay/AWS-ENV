# 🧪 Lab: Create an IAM Role Using AWS CLI

## 📌 Objective
Learn how to create an IAM role using the AWS CLI, attach the `AmazonS3ReadOnlyAccess` policy, and understand the trust policy.

---

## 🛠️ Prerequisites
- AWS CLI installed and configured
- Admin-level IAM permissions
- A trust policy JSON file (`trust-policy.json`)

---

## 🧩 Steps

### 1️⃣ Create a Trust Policy JSON File

Create a file called `trust-policy.json` in your current directory with the following content:

```json
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
