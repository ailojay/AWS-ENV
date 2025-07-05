import boto3
import json
import os
from datetime import datetime

def lambda_handler(event, context):
    iam = boto3.client('iam')
    s3 = boto3.client('s3')

    users_without_mfa = []
    users_with_keys = []

    try:
        users = iam.list_users()['Users']

        for user in users:
            username = user['UserName']

            # Check MFA devices
            mfa_devices = iam.list_mfa_devices(UserName=username)['MFADevices']
            if not mfa_devices:
                users_without_mfa.append(username)

            # Check Access Keys
            access_keys = iam.list_access_keys(UserName=username)['AccessKeyMetadata']
            if access_keys:
                users_with_keys.append(username)

        report = {
            "timestamp": datetime.utcnow().isoformat(),
            "users_without_mfa": users_without_mfa,
            "users_with_access_keys": users_with_keys
        }

        report_json = json.dumps(report, indent=2)

        # Upload to S3
        bucket_name = os.environ['BUCKET_NAME']
        file_name = f'iam-audit-report-{datetime.utcnow().strftime("%Y-%m-%dT%H-%M-%SZ")}.json'

        s3.put_object(
            Bucket=bucket_name,
            Key=file_name,
            Body=report_json,
            ContentType='application/json'
        )

        return {
            'statusCode': 200,
            'body': f'IAM audit completed. Report uploaded to {bucket_name}/{file_name}'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'errorMessage': str(e)
        }
