import boto3
import json
import os
from datetime import datetime

# AWS Clients
sns_client = boto3.client('sns')
s3_client = boto3.client("s3")
securityhub_client = boto3.client("securityhub")

# Environment Variables
sns_topic_arn = os.environ['SNS_TOPIC_ARN']
log_bucket = os.environ['S3_LOG_BUCKET']


def lambda_handler(event, context):
    findings = event.get("detail", {}).get("findings", [])

    for finding in findings:
        title = finding.get("Title", "")
        if "S3 Bucket allows public" in title:
            print("Finding ID:", finding.get("Id"))
            print("Product ARN:", finding.get("ProductArn"))

            bucket_arn = finding["Resources"][0]["Id"]
            bucket_name = bucket_arn.split(":::")[-1]

            # Block public access
            s3_client.put_public_access_block(
                Bucket=bucket_name,
                PublicAccessBlockConfiguration={
                    "BlockPublicAcls": True,
                    "IgnorePublicAcls": True,
                    "BlockPublicPolicy": True,
                    "RestrictPublicBuckets": True
                }
            )

            # Tag the bucket
            s3_client.put_bucket_tagging(
                Bucket=bucket_name,
                Tagging={
                    'TagSet': [
                        {'Key': 'Remediated', 'Value': 'True'},
                        {'Key': 'RemediatedBy', 'Value': 'S3RemediationLambda'},
                        {'Key': 'Timestamp', 'Value': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')}
                    ]
                }
            )

            # Send SNS alert
            message = f"Remediation applied to bucket: {bucket_name}\nReason: {title}"
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=message,
                Subject="S3 Bucket Remediation"
            )

            # Save log to S3
            log_key = f"remediation-logs/{bucket_name}-{datetime.utcnow().isoformat()}.json"
            s3_client.put_object(
                Bucket=log_bucket,
                Key=log_key,
                Body=json.dumps({
                    "bucket": bucket_name,
                    "remediation": "Blocked public access + Tagged",
                    "timestamp": datetime.utcnow().isoformat()
                })
            )

            # Update finding in Security Hub
            finding_id = finding.get("Id")
            if finding_id:
                securityhub_client.batch_update_findings(
                    FindingIdentifiers=[{
                        "Id": finding_id,
                        "ProductArn": finding.get("ProductArn")
                    }],
                    Note={
                        "Text": "Remediated: Public access blocked and bucket tagged.",
                        "UpdatedBy": "S3RemediationLambda"
                    },
                    Workflow={"Status": "RESOLVED"}
                )

    return {"status": "done"}
