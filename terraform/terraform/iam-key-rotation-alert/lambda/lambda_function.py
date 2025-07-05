import boto3
import os
from datetime import datetime, timezone, timedelta

def lambda_handler(event, context):
    client = boto3.client('iam')
    ses = boto3.client('ses')
    sender = os.environ['SENDER_EMAIL']

    response = client.list_users()
    report = ""

    for user in response['Users']:
        username = user['UserName']
        keys = client.list_access_keys(UserName=username)['AccessKeyMetadata']

        for key in keys:
            last_used = client.get_access_key_last_used(AccessKeyId=key['AccessKeyId'])
            last_used_date = last_used['AccessKeyLastUsed'].get('LastUsedDate')

            if not last_used_date or last_used_date < datetime.now(timezone.utc) - timedelta(days=90):
                report += f"⚠️  {username} - Access Key {key['AccessKeyId']} unused for 90+ days\n"

    if report:
        ses.send_email(
            Source=sender,
            Destination={"ToAddresses": [sender]},
            Message={
                "Subject": {"Data": "IAM Access Key Audit Alert"},
                "Body": {"Text": {"Data": report}}
            }
        )
