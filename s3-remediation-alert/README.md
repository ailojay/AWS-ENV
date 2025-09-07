# 🛡️ S3 Public Bucket Remediation Lambda

This project automatically remediates Amazon S3 buckets that allow **public access** using an AWS Lambda function triggered by **AWS Security Hub** findings.

## 📌 Features

- Detects `AwsS3Bucket` findings from Security Hub that indicate public read access
- Blocks all public access on the affected bucket
- Tags the bucket with a remediation marker
- Sends an SNS alert about the remediation
- Logs each remediation action to an S3 bucket
- Updates the Security Hub finding's workflow status to `RESOLVED` and adds a note

## 📂 Project Structure

