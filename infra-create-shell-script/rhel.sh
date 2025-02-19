#!/bin/bash

# Store each subnet in a separate variable
# Store each subnet in a separate variable
# shellcheck disable=SC2034
SUBNET_US_EAST_1A="subnet-0d6f188df6ab4cfee"
SUBNET_US_EAST_1B="subnet-084d096cd8e354551"
SUBNET_US_EAST_1C="subnet-0969c012e3344c524"
SUBNET_US_EAST_1D="subnet-00e05b15c4116939b"
SUBNET_US_EAST_1E="subnet-020eec5c0a3cff8ca"
SUBNET_US_EAST_1F="subnet-05821032acb47d88c"

##### Change these values ###
SG_NAME="allow-all"
REGION="us-east-1"  # Specify your desired AWS region here (e.g., us-east-1, us-west-2)
SUBNET_ID="$SUBNET_US_EAST_1C"  # Specify your subnet ID here
INSTANCE_TYPE="t2.micro"  # Specify your desired instance type here
#############################

create_ec2() {
  echo "Creating EC2 instance..."
  INSTANCE_DATA=$(aws ec2 run-instances \
      --region ${REGION} \
      --image-id ${AMI_ID} \
      --instance-type ${INSTANCE_TYPE} \
      --subnet-id ${SUBNET_ID} \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
      --security-group-ids ${SGID})
  
  INSTANCE_ID=$(echo ${INSTANCE_DATA} | jq -r '.Instances[].InstanceId')
  PRIVATE_IP=$(echo ${INSTANCE_DATA} | jq -r '.Instances[].PrivateIpAddress')

  echo "EC2 instance created with ID: ${INSTANCE_ID}"
  echo "Private IP: ${PRIVATE_IP}"

  echo "Retrieving public IP..."
  PUBLIC_IP=$(aws ec2 describe-instances --region ${REGION} --instance-ids ${INSTANCE_ID} \
      | jq -r '.Reservations[].Instances[].PublicIpAddress')

  if [ -z "${PUBLIC_IP}" ]; then
    echo "Public IP not yet assigned. The instance may take a few moments to initialize."
  else
    echo "Public IP: ${PUBLIC_IP}"
  fi
}

## Main Program

# Find the AMI ID based on a specific name filter
AMI_ID=$(aws ec2 describe-images --region ${REGION} --filters "Name=name,Values=RHEL-9-DevOps-Practice" | jq -r '.Images[].ImageId')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

# Retrieve the Security Group ID based on the security group name
SGID=$(aws ec2 describe-security-groups --region ${REGION} --filters "Name=group-name,Values=${SG_NAME}" | jq -r '.SecurityGroups[].GroupId')
if [ -z "${SGID}" ]; then
  echo "Given Security Group does not exist"
  exit 1
fi

# Validate the input for the component name
COMPONENT="${1}"
if [ -z "${COMPONENT}" ]; then
  echo "Input component name is needed"
  exit 1
fi

# Call the create_ec2 function to create the EC2 instance
create_ec2
