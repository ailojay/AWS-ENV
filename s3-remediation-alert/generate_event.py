import json

data = {
    "detail": {
        "findings": [
            {
                "Title": "S3 Bucket allows public read access",
                "Id": "test-finding-id-001",
                "ProductArn": "arn:aws:securityhub:us-east-1::product/aws/securityhub",
                "Resources": [
                    {
                        "Type": "AwsS3Bucket",
                        "Id": "arn:aws:s3:::my-public-bucket-726929447744"
                    }
                ]
            }
        ]
    }
}

with open("utf8-event.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)
