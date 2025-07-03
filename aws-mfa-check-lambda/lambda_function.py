import boto3
import os

sns_topic_arn = os.environ['SNS_TOPIC_ARN']

iam_client = boto3.client('iam')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    users_without_mfa = []

    paginator = iam_client.get_paginator('list_users')
    for response in paginator.paginate():
        for user in response['Users']:
            username = user['UserName']
            mfa_devices = iam_client.list_mfa_devices(UserName=username)['MFADevices']
            if len(mfa_devices) == 0:
                users_without_mfa.append(username)
    
    if users_without_mfa:
        message = "The following IAM users do NOT have MFA enabled:\n" + "\n".join(users_without_mfa)
    else:
        message = "All IAM users have MFA enabled."

    sns_client.publish(
        TopicArn=sns_topic_arn,
        Subject='IAM MFA Users Without MFA',
        Message=message
    )

    return {
        'statusCode': 200,
        'body': message
    }
