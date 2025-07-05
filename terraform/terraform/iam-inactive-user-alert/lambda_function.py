import os
import boto3
from datetime import datetime, timezone

def lambda_handler(event, context):
    ses_client = boto3.client('ses')
    iam_client = boto3.client('iam')

    ses_sender = os.environ['SES_SENDER']
    ses_recipient = os.environ['SES_RECIPIENT']

    now = datetime.now(timezone.utc)
    max_age_days = 90

    report = ""

    users = iam_client.list_users()['Users']
    for user in users:
        username = user['UserName']
        access_keys = iam_client.list_access_keys(UserName=username)['AccessKeyMetadata']

        for key in access_keys:
            key_id = key['AccessKeyId']
            create_date = key['CreateDate']
            age_days = (now - create_date).days

            if age_days > max_age_days:
                report += f"User: {username}, Key: {key_id}, Age: {age_days} days\n"

    if report:
        ses_client.send_email(
            Source=ses_sender,
            Destination={'ToAddresses': [ses_recipient]},
            Message={
                'Subject': {'Data': '⚠️ IAM Access Key Rotation Alert'},
                'Body': {'Text': {'Data': report}}
            }
        )

    return {
        'statusCode': 200,
        'body': 'Audit complete.'
    }
