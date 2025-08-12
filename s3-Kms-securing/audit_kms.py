import json

with open('/home/ailojay/AWS-ENV/s3-Kms-securing/kms-policy.json', 'r') as f:
    policy_data = json.load(f)
# Check if 'Policy' key exists and parse the inner policy
if 'Policy' in policy_data:
    inner_policy = json.loads(policy_data['Policy'])
else:
    inner_policy = policy_data  # Use directly if no 'Policy' wrapper
for statement in inner_policy.get('Statement', []):
    principal = statement.get('Principal', {})
    effect = statement.get('Effect')
    action = statement.get('Action')
    resource = statement.get('Resource')
    # Check for wildcard principal or broad permissions
    is_wildcard_principal = isinstance(principal.get('AWS'), str) and '*' in principal.get('AWS')
    is_broad_permission = (isinstance(action, (list, str)) and any('*' in str(a) for a in (action if isinstance(action, list) else [action]))) and (isinstance(resource, (list, str)) and '*' in str(resource))
    if effect == 'Allow' and (is_wildcard_principal or is_broad_permission):
        print("Warning: Wildcard principal or broad permissions detected!")