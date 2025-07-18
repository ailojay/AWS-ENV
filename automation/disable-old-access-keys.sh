#!/bin/bash

THRESHOLD_DAYS=90

echo "[+] Checking IAM users for access keys older than $THRESHOLD_DAYS days..."

users=$(aws iam list-users --query 'Users[].UserName' --output text)

for user in $users; do
    keys=$(aws iam list-access-keys --user-name "$user" --query 'AccessKeyMetadata[?Status==`Active`]' --output json)
    if [[ $keys == "[]" ]]; then
        echo "No active keys for user $user"
        continue
    fi

    echo "User: $user"

    for row in $(echo "${keys}" | jq -r '.[] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        key_id=$(_jq '.AccessKeyId')
        create_date=$(_jq '.CreateDate')
        create_ts=$(date -d "$create_date" +%s)
        now_ts=$(date +%s)
        age=$(( (now_ts - create_ts) / 86400 ))

        echo "Access key $key_id is $age days old."

        if (( age > THRESHOLD_DAYS )); then
            echo "Disabling access key $key_id for user $user..."
            aws iam update-access-key --user-name "$user" --access-key-id "$key_id" --status Inactive
        fi
    done
done

echo "[+] Remediation complete."
