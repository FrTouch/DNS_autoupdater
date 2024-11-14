#!/bin/bash

# This function will ask all the appropriate values for initializing the environment file
OVH_init() {
    askForValue "Enter your OVH Application Key:"
    setup_OVHAppKey=$ANSWER

    askForValue "Enter your OVH Application Secret:"
    setup_OVHAppSecret=$ANSWER

    askForValue "Enter your OVH Consumer Key:"
    setup_OVHConsKey=$ANSWER

    askForValue "Enter in seconds the TTL you wish to configure your record with (min: 300):"
    setup_OVHRecordTTL=$ANSWER
}

# This function retrieves the given record name value from OVH DNS servers
OVH_retrieveRecordValue() {
    echo "Checking record value"
    response=$(curl -s -X GET https://eu.api.ovh.com/v1/domain/zone/$DNSDomain/record?fieldType=$recordType&subDomain=$recordToCheck -H "authorization: Bearer $GandiAPIToken")
    checkError

    Provider_DNSRecordValue=$(echo "$response" | jq -r '.rrset_values[0]')
}

# This function updates the given record name value on OVH DNS servers
#OVH_updateRecordValue() {
#    echo "Updating record $DNSDomain.$recordToCheck with value $ipaddr"
#    response=$(curl -X PUT https://eu.api.ovh.com -H "authorization: Bearer $GandiAPIToken" -H 'content-type: application/json' -d '{"rrset_values":["'"$ipaddr"'"],"rrset_ttl":'$GandiRecordTTL'}')
#    echo $response
#    checkError
#}

applicationKey="142f5d6da73ed509"
applicationSecret="15543e9f145f062ee293a3bc8e316507"
consumerKey="f2fc139fb8c27ae3e8ba514a51336fb7"
timestamp=$(curl -X GET "https://eu.api.ovh.com/v1/auth/time" -H "accept: application/json")
method="GET"
url="https://eu.api.ovh.com/v1/domain/zone/pokedo.de/record?fieldType=A&subDomain=roamingv4"
body=""

signature="\$1\$$(echo -n "$applicationSecret+$consumerKey+$method+$url+$body+$timestamp" | sha1sum | awk '{print $1}')"
echo "signature="\$1\$$(echo -n "$applicationSecret+$consumerKey+$method+$url+$body+$timestamp" | sha1sum | awk '{print $1}')""

curl -v -X GET "https://eu.api.ovh.com/v1/domain/zone/pokedo.de/record?fieldType=A&subDomain=roamingv4" \
 -H "accept: application/json" \
 -H "X-Ovh-Application: $applicationKey" \
 -H "X-Ovh-Consumer: $consumerKey" \
 -H "X-Ovh-Signature: $signature" \
 -H "X-Ovh-Timestamp: $timestamp"
