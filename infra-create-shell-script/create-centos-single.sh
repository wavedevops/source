#!/bin/bash

##### Change these values ###
ZONE_ID="Z02090163Q152ZKQQQT6A"
SG_NAME="allow_all"
REGION="us-east-1d"  # Specify your desired AWS region here
#ENV="dev"
#############################


create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --region ${REGION} \
      --image-id ${AMI_ID} \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"  \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --region ${REGION} --change-batch file:///tmp/record.json | jq
}


## Main Program
AMI_ID=$(aws ec2 describe-images --region ${REGION} --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

SGID=$(aws ec2 describe-security-groups --region ${REGION} --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')
if [ -z "${SGID}" ]; then
  echo "Given Security Group does not exist"
  exit 1
fi


COMPONENT="${1}"
if [ -z "${COMPONENT}" ]; then
  echo "Input component name is needed"
  exit 1
fi

create_ec2
