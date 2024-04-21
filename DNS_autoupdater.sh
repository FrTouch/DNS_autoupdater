#!/bin/bash

. ./src/env.sh
. ./common/errChecker.sh
. ./utils/functions.sh

ipaddr=$(curl -s ifconfig.me/ip)
checkError

echo "Checking IP Address retrieved"
checkip $ipaddr

echo "Retrieving DNS record for -> $recordToCheck"
response=$(curl -s -X GET https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $APIToken")
checkError

DNSRecord=$(echo "$response" | jq -r '.rrset_values[0]')
checkip $DNSRecord
echo "DNS record for $recordToCheck retrieved from authority -> $DNSRecord"

if [ $DNSRecord == $ipaddr ]; then
  echo "Actual IP address equals the DNS record"
else
  echo "Actual IP differs from the DNS record"
  echo "Updating record"

  response=$(curl -X PUT https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $APIToken" -H 'content-type: application/json' -d '{"rrset_values":["'"$ipaddr"'"],"rrset_ttl":300}')
  echo $response
  checkError

  echo "Checking if change is effective"
  response=$(curl -s -X GET https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $APIToken")
  checkError

  DNSRecord=$(echo "$response" | jq -r '.rrset_values[0]')

  if [ $DNSRecord == $ipaddr ]; then
    echo "Record has been changed successfully"
  else
    echo "Record hasn't changed"
  fi

fi