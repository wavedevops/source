#!/bin/bash

# Replace these variables with your actual AWS credentials and region
AWS_ACCESS_KEY_ID=$(aws ssm get-parameter --name "access_key_id" --region "us-east-1" --query "Parameter.Value" --output text)
AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameter --name "secret_access_key" --region "us-east-1" --query "Parameter.Value" --output text)
AWS_REGION="us-east-1"

# Ensure AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Installing AWS CLI..."
    sudo yum update -y
    sudo yum install -y awscli
fi

# Create AWS credentials directory
mkdir -p ~/.aws
chmod 700 ~/.aws

# Configure AWS credentials
cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOL
chmod 600 ~/.aws/credentials

# Configure AWS config
cat <<EOL > ~/.aws/config
[default]
region = $AWS_REGION
output = json
EOL
chmod 600 ~/.aws/config

echo "AWS CLI has been configured successfully."
