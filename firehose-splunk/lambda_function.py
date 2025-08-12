import boto3
import gzip
import json
from io import BytesIO

s3 = boto3.client('s3')
firehose = boto3.client('firehose')

DELIVERY_STREAM_NAME = 'cloudtrail-to-splunk'

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    
    bucket = event['detail']['bucket']['name']
    key = event['detail']['object']['key']

    # Get and decompress the CloudTrail log file
    response = s3.get_object(Bucket=bucket, Key=key)
    compressed_data = response['Body'].read()

    with gzip.GzipFile(fileobj=BytesIO(compressed_data)) as f:
        log_data = f.read().decode('utf-8')

    # Parse JSON
    cloudtrail_data = json.loads(log_data)

    if "Records" in cloudtrail_data:
        for record in cloudtrail_data["Records"]:
            try:
                firehose.put_record(
                    DeliveryStreamName=DELIVERY_STREAM_NAME,
                    Record={'Data': json.dumps(record) + '\n'}
                )
            except Exception as e:
                print(f"Error sending record to Firehose: {e}")
    else:
        print("No 'Records' found in CloudTrail log file.")
