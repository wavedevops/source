#!/bin/bash

# Variables
ZONE_ID="Z0778341KVMO9YPSO08C"
NAME="workstation.chowdary.cloud."
TYPE="A"
TTL=10
NEW_RECORD=$1

# Check if a new record value is provided
if [ -z "$NEW_RECORD" ]; then
  echo "Usage: $0 <record_value>"
  exit 1
fi

# Get the current record value (if it exists)
CURRENT_RECORD=$(aws route53 list-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --query "ResourceRecordSets[?Name == '$NAME' && Type == '$TYPE']" \
  --output json | jq -r '.[0].ResourceRecords[0].Value')

# Handle case where no existing record is found
if [ "$CURRENT_RECORD" == "null" ] || [ -z "$CURRENT_RECORD" ]; then
  echo "No existing record found for $NAME"
  CURRENT_RECORD=""
else
  echo "Existing record found: $CURRENT_RECORD"
fi

# Create the UPSERT JSON payload
cat > upsert-change-batch.json <<EOF
{
  "Comment": "Upsert A record for $NAME",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$NAME",
        "Type": "$TYPE",
        "TTL": $TTL,
        "ResourceRecords": [
          {
            "Value": "$NEW_RECORD"
          }
        ]
      }
    }
  ]
}
EOF

# Apply the UPSERT operation
aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch file://upsert-change-batch.json

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated DNS record: $NAME to $NEW_RECORD"
else
  echo "Failed to update DNS record"
  exit 1
fi
