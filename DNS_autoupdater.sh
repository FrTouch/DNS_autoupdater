#!/bin/bash

. ./utils/functions.sh

if [[ $1 == "--setup" ]]; then
    echo "--setup invoked - starting script setup"

    if [[ -f ./src/env.sh ]]; then
        askYesNo "An environment file is already present, do you wish to backup it and continue setup ?"
        continueScript=$ANSWER
        if [[ $continueScript == false ]]; then
            echo "The setup will not continue. Exiting."
            exit 0
        else
            echo "Backuping environment file."
            mv ./src/env.sh ./src/bkp_env.sh
            echo "Previous environment file backuped, initializing new environment file."
            cp ./src/env.sh.dist ./src/env.sh
        fi
    else
        echo "Initializing environment file."
        cp ./src/env.sh.dist ./src/env.sh
    fi

    askForValue "Please enter your Domain Name:"
    setup_DomainName=$ANSWER

    askYesNo "Setup A record you use for your IPv4 address ? (Yes/No)"
    setup_isARecord=$ANSWER
    
    if [[ $setup_isARecord == true ]]; then
        askForValue "Enter your A record name:"
        setup_ARecord=$ANSWER
    fi

    askYesNo "Setup AAAA record you use for your IPv6 address ? (Yes/No)"
    setup_isAAAARecord=$ANSWER

    if [[ $setup_isAAAARecord == true ]]; then
        askForValue "Enter your AAAA record name:"
        setup_AAAARecord=$ANSWER
    fi

    if [[ $setup_isARecord == false && $setup_isAAAARecord == false ]]; then
        echo "You need to setup at least one record type to use this script. Exiting."
        exit 0
    fi

    askNumberedMenu "Who is your DNS provider ?" "Gandi OVH(soon) Scaleway(soon)"
    setup_provider=$ANSWER

    # We call the specific provider init function
    case "$setup_provider" in
        "Gandi")
            echo "Setuping Gandi provider"
            Gandi_init
            sed -i -e 's/DNSProvider\=""/DNSProvider\="'"$setup_provider"'"/' src/env.sh
            sed -i -e 's/GandiAPIToken\=""/GandiAPIToken\="'"$setup_GandiAPIToken"'"/' src/env.sh
            sed -i -e 's/GandiRecordTTL\=""/GandiRecordTTL\="'"$setup_GandiRecordTTL"'"/' src/env.sh
            ;;
        "Scaleway")
            echo "Setuping Scaleway provider"
            ;;
        *)
            echo "Provider unrecognized"
            helper
            exit 1
            ;;
    esac

    echo "Everything has been asked, are the following values correct ?"
    echo "    Provider selected -> $setup_provider"
    if [[ ! -z $setup_ARecord ]]; then echo "    A record Name -> $setup_ARecord"; else echo "    No A record provided"; fi
    if [[ ! -z $setup_AAAARecord ]]; then echo "    AAAA record Name -> $setup_AAAARecord"; else echo "    No AAAA record provided"; fi 
    askYesNo "Are those values correct ?"  
    continueScript=$ANSWER
    if [[ $continueScript == false ]]; then
        echo "The setup will not complet. Exiting."
        exit 0
    else
        echo "Applying configuration according to the setup provided."
        sed -i -e 's/DNSDomain\=""/DNSDomain\="'"$setup_DomainName"'"/' src/env.sh
        sed -i -e 's/DNSRecordV4\=""/DNSRecordV4\="'"$setup_ARecord"'"/' src/env.sh
        sed -i -e 's/DNSRecordV6\=""/DNSRecordV6\="'"$setup_AAAARecord"'"/' src/env.sh
    fi

    askYesNo "Setup completed, do you with to execute the script now ?"
    continueScript=$ANSWER
    if [[ $continueScript == false ]]; then
        echo "Exiting script."
        exit 0
    else
        echo "Continuing script."
    fi
fi

# Loading environment variables
. ./src/env.sh

# Loading functions used for querying DNS informations
. ./utils/dnfunctions.sh

# Loading providers functions
. ./providers/gandi.sh

#### Process ####

echo "Retrieving actual public IP in use for your workstation"
ipaddr=$(curl -s ifconfig.me/ip)
checkError
echo "Checking IP Address type"
checkip $ipaddr

echo "Your provider configured is $DNSProvider"

echo "Checking DNS record value for record $recordToCheck.$DNSDomain"
getDNSRecordValue $recordToCheck.$DNSDomain $recordType
checkError
echo "DNS record value for record $recordToCheck.$DNSDomain is: $DNSrecordValue"

if [[ $DNSrecordValue == $ipaddr ]]; then
    echo "Actual IP address equals the DNS record, there is nothing to do."
    exit 0
else
    askYesNo "Actual IP differs from the DNS record, do you wish to update it with your actual Public IP ?"
    updateDNS=$ANSWER

    if [[ $updateDNS == false ]]; then
        echo "DNS record will not be updated."
        exit 0
    fi

    echo "Trying to update record"
    eval "${DNSProvider}_updateRecordValue"

    echo "Verifying if values has been applied"
    eval "${DNSProvider}_retrieveRecordValue"

    
    if [[ $Provider_DNSRecordValue == $ipaddr ]]; then
      echo "Record has been updated successfully"
      echo "Verifying name resolution to check if name have been propagated (TODO)"

    else
      echo "Record couldn't be changed"
    fi

fi