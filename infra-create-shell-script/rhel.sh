#!/bin/bash

# Define variables
INSTANCE_TYPE="t3.micro"
AMI_NAME="RHEL-9-DevOps-Practice"
KEY_NAME="$1"
SECURITY_GROUP="allow_all"
REGION="us-east-1"
AVAILABILITY_ZONE="us-east-1d"

# Get the latest AMI ID based on the AMI name
AMI_ID=$(aws ec2 describe-images \
    --filters "Name=name,Values=$AMI_NAME" \
    --query 'Images[0].ImageId' \
    --output text \
    --region $REGION)

if [ -z "$AMI_ID" ]; then
    echo "Error: AMI with name '$AMI_NAME' not found."
    exit 1
fi

# Create the Spot Instance Request
SPOT_REQUEST_ID=$(aws ec2 request-spot-instances \
    --instance-count 1 \
    --type "persistent" \
    --launch-specification "{
        \"ImageId\": \"$AMI_ID\",
        \"InstanceType\": \"$INSTANCE_TYPE\",
        \"KeyName\": \"$KEY_NAME\",
        \"SecurityGroupIds\": [\"$SECURITY_GROUP\"],
        \"Placement\": { \"AvailabilityZone\": \"$AVAILABILITY_ZONE\" }
    }" \
    --region $REGION \
    --query 'SpotInstanceRequests[0].SpotInstanceRequestId' \
    --output text)

if [ $? -ne 0 ]; then
    echo "Error creating Spot Instance Request in $AVAILABILITY_ZONE"
    exit 1
fi

echo "Spot Instance Request ID: $SPOT_REQUEST_ID in $AVAILABILITY_ZONE"

# Set the instance interruption behavior to 'stop'
aws ec2 modify-spot-instance-request \
    --spot-instance-request-id "$SPOT_REQUEST_ID" \
    --instance-interruption-behavior "stop" \
    --region $REGION

if [ $? -eq 0 ]; then
    echo "Set interruption behavior to 'stop' in $AVAILABILITY_ZONE."
else
    echo "Failed to set interruption behavior in $AVAILABILITY_ZONE."
fi

