import boto3
import json
import os
import logging
from botocore.exceptions import ClientError

cloudtrail = boto3.client("cloudtrail")
ses = boto3.client("ses")

def lambda_handler(event, context):
    logging.getLogger().setLevel(logging.INFO)
    logging.info(f"Processing CloudTrail status for instance {event.get('detail', {}).get('instance-id', 'N/A')}")
    # Get all CloudTrail trails
    trails = cloudtrail.describe_trails()
    actions_taken = False
    
    for trail in trails["trailList"]:
        is_logging = trail.get("IsLogging", False)
        trail_name = trail["Name"]
        
        if not is_logging:
            actions_taken = True
            try:
                ses.send_email(
                    Source=os.environ["SES_SOURCE_EMAIL"],
                    Destination={"ToAddresses": [os.environ["SES_DEST_EMAIL"]]},
                    Message={
                        "Subject": {"Data": f"CloudTrail Stopped: {trail_name}"},
                        "Body": {
                            "Text": {
                                "Data": f"CloudTrail {trail_name} has stopped logging. Re-enabling now."
                            }
                        }
                    }
                )
                cloudtrail.start_logging(Name=trail_name)
                logging.info(f"Re-enabled CloudTrail {trail_name} and sent alert.")
            except ClientError as e:
                logging.error(f"Error processing trail {trail_name}: {str(e)}")
                continue
    
    if actions_taken:
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Actions were taken to re-enable CloudTrail logging"})
        }
    else:
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "All CloudTrail trails are active"})
        }