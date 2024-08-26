#!/bin/bash

# Define variables
INSTANCE_TYPE="t3.micro"  # Change to your desired instance type
AMI_NAME="RHEL-9-DevOps-Practice"  # Replace with your desired AMI name
KEY_NAME="$1"  # Pass your key pair name as the first argument
SECURITY_GROUP_NAME="allow_all"  # Replace with your security group name
REGION="us-east-1"  # Change to your desired region
AVAILABILITY_ZONE="us-east-1a"  # Specify the single Availability Zone

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

# Get the security group ID based on the security group name
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" \
    --query 'SecurityGroups[0].GroupId' \
    --output text \
    --region $REGION)

if [ -z "$SECURITY_GROUP_ID" ]; then
    echo "Error: Security group with name '$SECURITY_GROUP_NAME' not found."
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
        \"SecurityGroupIds\": [\"$SECURITY_GROUP_ID\"],
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
