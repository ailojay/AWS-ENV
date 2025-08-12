import json
import boto3
import gzip

firehose = boto3.client('firehose')

def lambda_handler(event, context):
    print("Incoming Event:", json.dumps(event))

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        print(f"Processing s3://{bucket}/{key}")

        # Get file from S3
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=bucket, Key=key)
        print("File size (bytes):", obj['ContentLength'])

        # Read and decompress if needed
        body = obj['Body'].read()
        if key.endswith('.gz'):
            try:
                body = gzip.decompress(body)
                print("Gzip decompression successful")
            except Exception as e:
                print("Gzip decompression failed:", e)
                continue

        # Convert to string
        payload = body.decode('utf-8')
        print("First 200 chars of payload:", payload[:200])

        # Send to Firehose
        response = firehose.put_record(
            DeliveryStreamName='CloudTrailToSplunk-S3Source',
            Record={'Data': payload + "\n"}
        )
        print("Firehose response:", response)
