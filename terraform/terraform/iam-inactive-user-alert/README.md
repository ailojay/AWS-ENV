# 🛡️ IAM Inactive User Detection and Alerting (Terraform)

## 📍 Project Objective

Automatically detect IAM users with inactive access keys and send alert emails using AWS Lambda, EventBridge, and SES. The entire infrastructure is provisioned and managed using Terraform.

---

## 🧰 Tools & AWS Services Used

- **Terraform** – Infrastructure as Code (IaC)
- **AWS Lambda** – Serverless function to check for inactive users
- **AWS IAM** – IAM user and access key audit
- **Amazon EventBridge (CloudWatch Events)** – Scheduled invocation of Lambda
- **Amazon SES** – Email alerts for inactive users

---

## 📁 Project Structure

```bash
iam-inactive-user-alert/
├── iam.tf               # IAM role and policies for Lambda
├── lambda.tf            # Lambda function definition
├── eventbridge.tf       # CloudWatch Event rule & target setup
├── ses.tf               # SES email identity verification & policy
├── main.tf              # Provider configuration
├── secrets.tfvars       # Contains sender/recipient email (ignored by Git)
├── lambda_function.py   # Python script for Lambda (zipped before apply)
└── lambda.zip           # Zipped Lambda code for deployment
