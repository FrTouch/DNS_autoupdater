#!/bin/bash

# This function will ask all the appropriate values for initializing the environment file
Gandi_init() {
    askForValue "Enter your Gandi API Token:"
    setup_GandiAPIToken=$ANSWER

    askForValue "Enter in seconds the TTL you wish to configure your record with (min: 300):"
    setup_GandiRecordTTL=$ANSWER
}

# This function retrieves the given record name value from Gandi DNS servers
Gandi_retrieveRecordValue() {
    echo "Checking record value"
    response=$(curl -s -X GET https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $GandiAPIToken")
    checkError

    Provider_DNSRecordValue=$(echo "$response" | jq -r '.rrset_values[0]')
}

# This function updates the given record name value on Gandi DNS servers
Gandi_updateRecordValue() {
    echo "Updating record $DNSDomain.$recordToCheck with value $ipaddr"
    response=$(curl -X PUT https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $GandiAPIToken" -H 'content-type: application/json' -d '{"rrset_values":["'"$ipaddr"'"],"rrset_ttl":'$GandiRecordTTL'}')
    echo $response
    checkError
}


#echo "Retrieving DNS record for -> $recordToCheck"
#response=$(curl -s -X GET https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $APIToken")
#checkError
#DNSRecord=$(echo "$response" | jq -r '.rrset_values[0]')
#checkip $DNSRecord
#echo "DNS record for $recordToCheck retrieved from authority -> $DNSRecord"