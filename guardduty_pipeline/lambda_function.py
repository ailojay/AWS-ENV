import json
import boto3
import botocore.exceptions
import os

def lambda_handler(event, context):
    ses = boto3.client('ses')
    s3 = boto3.client('s3')
    
    finding = event['detail']
    instance_id = finding['resource']['instanceDetails']['instanceId']
    bucket_name = f"{os.environ['S3_BUCKET_PREFIX']}-{finding['accountId'][-8:]}"
    ses_email_source = os.environ['SES_EMAIL_SOURCE']
    ses_email_recipient = os.environ['SES_EMAIL_RECIPIENT']
    
    # 🧪 MOCK EC2 TERMINATION
    try:
        print(f"[MOCK] Pretending to terminate instance {instance_id}")
    except Exception as e:
        print(f"[MOCK] Error 'terminating' instance {instance_id}: {e}")
        return {'statusCode': 500, 'body': f'[MOCK] Error: {e}'}
    
    # ✅ Store finding in S3
    try:
        s3.put_object(
            Bucket=bucket_name,
            Key=f"findings/{finding['id']}.json",
            Body=json.dumps(finding)
        )
        print(f"✅ Finding stored in S3 bucket {bucket_name}")
    except botocore.exceptions.ClientError as e:
        print(f"❌ Error storing finding in S3: {e}")
    
    # ✅ Send SES notification
    try:
        ses.send_email(
            Source=ses_email_source,
            Destination={'ToAddresses': [ses_email_recipient]},
            Message={
                'Subject': {'Data': 'Crypto Mining Detected'},
                'Body': {'Text': {'Data': f'[MOCK] Instance {instance_id} terminated due to crypto mining. Finding stored in S3.'}}
            }
        )
        print(f"✅ SES alert sent to {ses_email_recipient}")
    except botocore.exceptions.ClientError as e:
        print(f"❌ Error sending SES email: {e}")
    
    return {'statusCode': 200, 'body': f'[MOCK] Instance {instance_id} terminated, finding stored'}
