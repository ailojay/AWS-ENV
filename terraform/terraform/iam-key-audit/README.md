# IAM Access Key Audit with SES Alerts (Terraform)

This project automates auditing of AWS IAM users' access keys. It uses:
- **AWS Lambda** to detect old access keys.
- **Amazon S3** to store audit reports.
- **Amazon SES** to send email alerts.
- **EventBridge** to trigger audits on a weekly schedule.
- **Terraform** to manage all infrastructure.

---

## 📁 Project Structure

