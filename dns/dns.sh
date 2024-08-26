#!/bin/bash

# Variables (replace with your actual values)
CF_API_TOKEN="MUq7N2wbD0bl0Ui4xnUOoBJyhSZOQs25AfrALb6e"
ZONE_ID="a79870cd6e15bc4bf5c8ef14dbb14bc9"
DNS_RECORD_TYPE="A"  # Type of DNS record, e.g., A, CNAME, TXT
DNS_RECORD_NAME="db.chowdary.cloud"  # The name of the DNS record
DNS_RECORD_CONTENT="1.1.1.1"  # The IP address or content for the DNS record
DNS_RECORD_TTL=5  # Time to live, in seconds
PROXIED=false  # Whether the record is proxied (true/false)

# API endpoint
CF_API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"

# Create the DNS record
response=$(curl -s -X POST "$CF_API_URL" \
     -H "Authorization: Bearer $CF_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "'"$DNS_RECORD_TYPE"'",
       "name": "'"$DNS_RECORD_NAME"'",
       "content": "'"$DNS_RECORD_CONTENT"'",
       "ttl": '"$DNS_RECORD_TTL"',
       "proxied": '"$PROXIED"'
     }')

# Check if the DNS record creation was successful
if echo "$response" | grep -q '"success":true'; then
  echo "DNS record created successfully."
else
  echo "Failed to create DNS record."
  echo "Response from Cloudflare API: $response"
fi
