#!/bin/bash

# Retrieve DNS record value where:
#    - $1 = Name to check
#    - $2 = Record type
getDNSRecordValue() {
    domainName=$1
    recordType=$2

    # Retrieve name value using dig
    DNSrecordValue=$(dig +short "$domainName" "$recordType" | tail -n1)
}