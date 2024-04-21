#!/bin/bash

# This function checks if the IP Address retrieved from ifconfig.me is an IPv4 or IPv6
checkip() {
    regex_ipv4='([0-9]{1,3}\.){3}[0-9]{1,3}'
    regex_ipv6='([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}'

    if [[ $1 =~ $regex_ipv4 ]]; then
        echo "IPv4 identified: $1"
        recordToCheck=$DNSRecordV4
        recordType="A"
    elif [[ $1 =~ $regex_ipv6 ]]; then
        echo "IPv6 identified: $1"
        recordToCheck=$DNSRecordV6
        recordType="AAAA"
    else
        echo "No IP identified, exiting."
        exit 1
    fi
}