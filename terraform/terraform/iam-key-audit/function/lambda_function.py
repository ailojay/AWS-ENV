import boto3
import os
from datetime import datetime, timezone

def lambda_handler(event, context):
    iam = boto3.client('iam')
    ses = boto3.client('ses')

    sender = os.environ['SES_SENDER']
    recipient = os.environ['SES_RECIPIENT']
    max_age_days = int(os.environ.get('MAX_AGE_DAYS', '90'))  # reset to 90

    old_keys = []

    users = iam.list_users()['Users']
    print(f"Found {len(users)} users.")

    for user in users:
        username = user['UserName']
        print(f"Checking user: {username}")

        keys = iam.list_access_keys(UserName=username)['AccessKeyMetadata']
        for key in keys:
            create_date = key['CreateDate']
            age = (datetime.now(timezone.utc) - create_date).days
            print(f"  Key {key['AccessKeyId']} is {age} days old.")

            if age > max_age_days:
                print(f"  -> OLD KEY DETECTED for {username}")
                old_keys.append({
                    'UserName': username,
                    'AccessKeyId': key['AccessKeyId'],
                    'AgeInDays': age
                })

    if old_keys:
        body = "The following IAM users have access keys older than {} days:\n\n".format(max_age_days)
        for entry in old_keys:
            body += f"User: {entry['UserName']}, AccessKeyId: {entry['AccessKeyId']}, Age: {entry['AgeInDays']} days\n"

        print("Sending email via SES...")
        try:
            ses.send_email(
                Source=sender,
                Destination={'ToAddresses': [recipient]},
                Message={
                    'Subject': {'Data': '⚠️ AWS IAM Access Key Rotation Alert'},
                    'Body': {'Text': {'Data': body}}
                }
            )
            print("Email sent successfully.")
        except Exception as e:
            print(f"Failed to send email: {e}")
    else:
        print("No old keys found.")

    return {
        'statusCode': 200,
        'body': 'IAM access key audit complete. Email sent if old keys were found.'
    }
