# 🧪 Lab: Create an IAM User Using AWS CLI

## 📌 Objective
Create a new IAM user via AWS CLI, assign the `ReadOnlyAccess` policy, and verify the setup.

---

## 🛠️ Prerequisites
- AWS CLI installed and configured with an IAM user that has `iam:*` permissions
- Admin access to your AWS account

---

## 🧾 Steps

### 1. ✅ Create the IAM User
```bash
aws iam create-user --user-name lab-user
