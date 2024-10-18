# #!/bin/bash

# # ANSI color codes
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m' # No Color

# # Variables
# ZONE_ID="Z0778341KVMO9YPSO08C"
# NAME="jenkins.chowdary.cloud"
# TYPE="A"
# TTL=10
# RECORDS=$1

# # Check if RECORDS variable is provided
# if [ -z "$RECORDS" ]; then
#   echo -e "${RED}Usage: $0 <record_value>${NC}"
#   exit 1
# fi

# # Get the current record value
# CURRENT_RECORD=$(aws route53 list-resource-record-sets \
#   --hosted-zone-id $ZONE_ID \
#   --query "ResourceRecordSets[?Name == '$NAME.']" \
#   --output json | jq -r '.[0].ResourceRecords[0].Value')

# # Check if the record exists
# if [ -n "$CURRENT_RECORD" ]; then
#   # Create JSON payload to delete the existing record
#   cat > delete-change-batch.json <<EOF
# {
#   "Comment": "Delete A record for $NAME",
#   "Changes": [
#     {
#       "Action": "DELETE",
#       "ResourceRecordSet": {
#         "Name": "$NAME",
#         "Type": "$TYPE",
#         "TTL": $TTL,
#         "ResourceRecords": [
#           {
#             "Value": "$CURRENT_RECORD"
#           }
#         ]
#       }
#     }
#   ]
# }
# EOF

#   # Delete the existing record
#   aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file://delete-change-batch.json

#   echo -e "${YELLOW}Deleted existing record: $CURRENT_RECORD${NC}"
# fi

# # Create JSON payload to create the new record
# cat > create-change-batch.json <<EOF
# {
#   "Comment": "Create A record for $NAME",
#   "Changes": [
#     {
#       "Action": "CREATE",
#       "ResourceRecordSet": {
#         "Name": "$NAME",
#         "Type": "$TYPE",
#         "TTL": $TTL,
#         "ResourceRecords": [
#           {
#             "Value": "$RECORDS"
#           }
#         ]
#       }
#     }
#   ]
# }
# EOF

# # Create the new record
# aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file://create-change-batch.json

# echo -e "${GREEN}Created new record: $RECORDS${NC}"


#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
ZONE_ID="Z0013695SMHQDK42GJB1"
NAME="jenkins.chowdary.cloud"
TYPE="A"
TTL=10
RECORDS=$1

# Check if RECORDS variable is provided
if [ -z "$RECORDS" ]; then
  echo -e "${RED}Usage: $0 <record_value>${NC}"
  exit 1
fi

# Get the current record value safely
CURRENT_RECORD=$(aws route53 list-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --query "ResourceRecordSets[?Name == '$NAME.'].ResourceRecords[0].Value" \
  --output text 2>/dev/null)

if [ "$CURRENT_RECORD" == "None" ] || [ -z "$CURRENT_RECORD" ]; then
  echo -e "${YELLOW}No existing record found for $NAME.${NC}"
else
  # Create JSON payload to delete the existing record
  cat > delete-change-batch.json <<EOF
{
  "Comment": "Delete A record for $NAME",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "$NAME",
        "Type": "$TYPE",
        "TTL": $TTL,
        "ResourceRecords": [
          {
            "Value": "$CURRENT_RECORD"
          }
        ]
      }
    }
  ]
}
EOF

  # Delete the existing record
  aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file://delete-change-batch.json

  echo -e "${YELLOW}Deleted existing record: $CURRENT_RECORD${NC}"
fi

# Create JSON payload to create the new record
cat > create-change-batch.json <<EOF
{
  "Comment": "Create A record for $NAME",
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "$NAME",
        "Type": "$TYPE",
        "TTL": $TTL,
        "ResourceRecords": [
          {
            "Value": "$RECORDS"
          }
        ]
      }
    }
  ]
}
EOF

# Create the new record
aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file://create-change-batch.json

echo -e "${GREEN}Created new record: $RECORDS${NC}"
