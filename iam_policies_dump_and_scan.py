import boto3
import json
import os
import subprocess

# Create policies directory if not exists
if not os.path.exists("policies"):
    os.makedirs("policies")

iam = boto3.client("iam")

# Fetch all managed policies
paginator = iam.get_paginator("list_policies")
page_iterator = paginator.paginate(Scope="All")

print("[*] Fetching IAM policies...")
for page in page_iterator:
    for policy in page["Policies"]:
        policy_arn = policy["Arn"]
        policy_name = policy["PolicyName"]

        # Get policy default version
        versions = iam.list_policy_versions(PolicyArn=policy_arn)
        default_version_id = next(v["VersionId"] for v in versions["Versions"] if v["IsDefaultVersion"])
        default_version = iam.get_policy_version(PolicyArn=policy_arn, VersionId=default_version_id)

        policy_doc = default_version["PolicyVersion"]["Document"]

        # Save to JSON file
        file_path = f"policies/{policy_name}.json"
        with open(file_path, "w") as f:
            json.dump(policy_doc, f, indent=2)

print("[*] All IAM policies saved to 'policies/' folder.")

# Merge all JSON policies into one
print("[*] Merging all policies into one file...")
with open("all_policies.json", "w") as outfile:
    merged = []
    for filename in os.listdir("policies"):
        if filename.endswith(".json"):
            with open(os.path.join("policies", filename)) as f:
                merged.append(json.load(f))
    json.dump(merged, outfile, indent=2)

print("[*] Merged policies saved to 'all_policies.json'.")

# Run cloudsplaining scan
print("[*] Running cloudsplaining scan...")
subprocess.run([
    "cloudsplaining", "scan",
    "--input-file", "all_policies.json",
    "--output-file", "cloudsplaining_report.html"
])

print("[✔] cloudsplaining_report.html generated! Open it in your browser.")
