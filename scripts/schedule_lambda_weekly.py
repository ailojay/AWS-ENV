import boto3

# ---------------------- CONFIGURATION ----------------------
lambda_function_name = 'checkMFA'  # Replace with your Lambda function name
rule_name = 'weekly-mfa-check'
schedule_expression = 'cron(0 9 ? * 2 *)'  # Monday at 9 AM UTC
region = 'us-east-1'  # Replace if needed
# -----------------------------------------------------------

# Create clients
events_client = boto3.client('events', region_name=region)
lambda_client = boto3.client('lambda', region_name=region)

# 1. Create EventBridge rule
print(f"Creating rule '{rule_name}'...")
response = events_client.put_rule(
    Name=rule_name,
    ScheduleExpression=schedule_expression,
    State='ENABLED',
    Description='Triggers Lambda function to check MFA weekly on Mondays'
)
rule_arn = response['RuleArn']
print(f"Rule ARN: {rule_arn}")

# 2. Add Lambda function as target
print("Adding Lambda target to the rule...")
events_client.put_targets(
    Rule=rule_name,
    Targets=[
        {
            'Id': '1',
            'Arn': lambda_client.get_function(FunctionName=lambda_function_name)['Configuration']['FunctionArn']
        }
    ]
)

# 3. Grant permission for EventBridge to invoke Lambda
print("Adding permission to allow EventBridge to invoke Lambda...")
lambda_client.add_permission(
    FunctionName=lambda_function_name,
    StatementId='eventbridge-invoke-weekly',
    Action='lambda:InvokeFunction',
    Principal='events.amazonaws.com',
    SourceArn=rule_arn
)

print("✅ Scheduled rule created successfully.")
