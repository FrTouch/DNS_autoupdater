#!/bin/bash

# Function used to check if any error happened during command execution
checkError() {
    return_code=$?
    if [ $return_code -eq 0 ]; then
        echo "  Command OK"
    else
        echo "Error while executing command, error code : $return_code"
        return $return_code
    fi
}

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

# Asks for a simple value to be entered where:
#    - $1 : Question to ask
askForValue() {
    QUESTION=$1

    while true; do
        read -rp "$QUESTION" ANSWER
        if [[ -n "$ANSWER" ]]; then
            break
        else
            echo "Value can't be empty. Please enter a value:"
        fi
    done
}

# Yes/No question where:
#    - $1 : Question to ask
askYesNo() {
    QUESTION=$1

    while true; do
        read -rp "$QUESTION" ANSWER
        case "$ANSWER" in
            [Yy]|[Yy][Ee][Ss]) ANSWER=true; return 0 ;;
            [Nn]|[Nn][Oo]) ANSWER=false; return 1 ;;
            *) echo "Invalid answer. Please enter 'Yes' or 'No'." ;;
        esac
    done
}

askNumberedMenu() {
    # $1 = Question à poser
    # $2 = liste des éléments séparés par un espace
    # $3 (optionnal) = index de l'élément par défaut
 
    QUESTION=$1
    read -ra OPTIONS  <<< "$2" # Obtention de la liste de options
 
    if [ -n "$3" ]; then       # Si donné par l'utilisateur (c-à-d variable non vide)
        DEFAULT=$3
    else                       # Sinon, valeur par défaut
        DEFAULT=1
    fi
 
    # Show 
    printf "\n"
    for i in $(seq ${#OPTIONS[@]}); do                        # on compte le nombre d'options
        printf '    %3s %s\n' "$i)" "${OPTIONS[$(($i-1))]}"   # On affiche la position dans la liste et la valeur de l'option
    done
    printf '\n'
 
    # ask user
    printf "\x1b[1;32m$QUESTION\x1b[0m"          # Un peu de couleur (gras + vert)
    read -p " [$DEFAULT] : " -r INPUT            # Demande valeur sans retour à la ligne
    INPUT=${INPUT:-${DEFAULT}}                   # Substitut par $DEFAULT si réponse vide
 
    # Collect result
    if [[ "$(seq ${#OPTIONS[@]})" =~ "$INPUT" ]]; then
        ANSWER="${OPTIONS[$(($INPUT-1))]}"
    else

        if [ -z $3 ]; then
        echo "Wrong option: $INPUT"
        else
            ANSWER="${OPTIONS[$(($DEFAULT-1))]}"
        fi

    fi

    #return $ANSWER
}

# Helper - show in case of a missuse of the script, or if called using the --help parameter
function helper {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --setup                   Launches setup process of the script"
    #echo "  -f, --file </path/to/file>   File to check"
    #echo "  -p, --provider <providername>   Specifies your DNS provider where your domain is hosted"
    echo "  -h, --help                Shows this helper"
    exit 0
}