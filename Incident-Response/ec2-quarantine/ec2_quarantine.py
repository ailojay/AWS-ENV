import boto3
import os
import logging
import base64
import json
from botocore.exceptions import ClientError

ec2 = boto3.client("ec2")

def lambda_handler(event, context):
    logging.getLogger().setLevel(logging.INFO)
    # Log raw event as string
    logging.info(f"Raw event received: {str(event)[:50]}...")
    # Handle event as dictionary or string
    try:
        if isinstance(event, dict):
            logging.info(f"Event is dictionary: {event}")
            event = json.dumps(event)  # Convert dict to JSON string
        elif isinstance(event, str):
            logging.info(f"Attempting to decode base64: {event[:50]}...")
            try:
                event = base64.b64decode(event).decode('utf-8')
                logging.info(f"Decoded event: {event}")
            except base64.binascii.Error:
                logging.info("Not a valid base64 string")
        event = json.loads(event) if isinstance(event, str) else event
        logging.info(f"Parsed event: {event}")
    except json.JSONDecodeError as e:
        logging.error(f"Error parsing JSON: {str(e)}")
        return {"statusCode": 400, "body": "Invalid JSON format"}
    except Exception as e:
        logging.error(f"Error processing event: {str(e)}")
        return {"statusCode": 400, "body": "Invalid event format"}
    instance_id = event.get('detail', {}).get('instance-id')
    logging.info(f"Processing quarantine for instance {instance_id or 'N/A'}")
    if not instance_id:
        return {"statusCode": 400, "body": "No instance-id provided in event."}
    try:
        ec2.modify_network_interface_attribute(
            NetworkInterfaceId=next(interface['NetworkInterfaceId'] for interface in ec2.describe_network_interfaces(Filters=[{'Name': 'attachment.instance-id', 'Values': [instance_id]}])['NetworkInterfaces']),
            Groups=[os.environ["QUARANTINE_SG_ID"]]
        )
        logging.info(f"Quarantined instance {instance_id}")
        return {"statusCode": 200, "body": f"Instance {instance_id} quarantined"}
    except ClientError as e:
        logging.error(f"Error quarantining {instance_id}: {str(e)}")
        return {"statusCode": 500, "body": f"Error: {str(e)}"}