#!/bin/bash

##### Change these values ###
SG_NAME="allow_all"
REGION="us-east-1"  # Specify your desired AWS region here (e.g., us-east-1, us-west-2)
#############################

create_ec2() {
  echo "Creating EC2 instance..."
  PRIVATE_IP=$(aws ec2 run-instances \
      --region ${REGION} \
      --image-id ${AMI_ID} \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
      --security-group-ids ${SGID} \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  echo "EC2 instance created with IP: ${PRIVATE_IP}"
}

## Main Program

# Find the AMI ID based on a specific name filter
AMI_ID=$(aws ec2 describe-images --region ${REGION} --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

# Retrieve the Security Group ID based on the security group name
SGID=$(aws ec2 describe-security-groups --region ${REGION} --filters "Name=group-name,Values=${SG_NAME}" | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')
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

