import boto3
import os

ses = boto3.client('ses', region_name=os.environ.get('AWS_REGION', 'us-east-1'))

SES_SENDER = os.environ['SES_SENDER']        # Must be a verified sender in SES
SES_RECIPIENT = os.environ['SES_RECIPIENT']  # Must be a verified recipient if in SES sandbox

def lambda_handler(event, context):
    findings = event.get("detail", {}).get("findings", [])
    if not findings:
        print("No findings in event.")
        return {"status": "No findings"}

    for finding in findings:
        finding_id = finding.get("Id", "N/A")
        title = finding.get("Title", "N/A")
        description = finding.get("Description", "N/A")
        resource = finding.get("Resources", [{}])[0].get("Id", "N/A")

        message = f"""
        🔒 AWS Access Analyzer Alert

        �� Title: {title}
        🔹 Description: {description}
        🔹 Resource: {resource}
        🔹 Finding ID: {finding_id}
        """

        try:
            response = ses.send_email(
                Source=SES_SENDER,
                Destination={"ToAddresses": [SES_RECIPIENT]},
                Message={
                    "Subject": {"Data": "AWS Access Analyzer Alert"},
                    "Body": {"Text": {"Data": message}}
                }
            )
            print(f"Email sent: {response['MessageId']}")
        except Exception as e:
            print(f"Failed to send email: {e}")
            return {"status": "error", "message": str(e)}

    return {"status": "success", "processed": len(findings)}
