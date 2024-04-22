#!/bin/bash

# This function will ask all the appropriate values for initializing the environment file
GANDI_init() {
    askForValue "Enter your Gandi API Token:"
    setup_GandiAPIToken=$ANSWER

    askForValue "Enter in seconds the TTL you wish to configure your record with (min: 300):"
    setup_GandiRecordTTL=$ANSWER
}

# This function retrieves the given record name value from Gandi DNS servers
GANDI_retrieveRecordValue() {

}

# This function updates the given record name value on Gandi DNS servers
GANDI_updateRecordValue() {

}


#echo "Retrieving DNS record for -> $recordToCheck"
#response=$(curl -s -X GET https://api.gandi.net/v5/livedns/domains/$DNSDomain/records/$recordToCheck/$recordType -H "authorization: Bearer $APIToken")
#checkError
#DNSRecord=$(echo "$response" | jq -r '.rrset_values[0]')
#checkip $DNSRecord
#echo "DNS record for $recordToCheck retrieved from authority -> $DNSRecord"