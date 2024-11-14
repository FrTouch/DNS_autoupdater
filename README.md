# DNS_autoupdater

This Bash script can be used to automatically update an A or AAAA type DNS record depending of your current public IP.

**Usecase** You need to access a firewall protected environment, and a DNS record has been setup so that your firewall can dynamically resolve and allow the IP address behing your record.

Currently supports the following DNS providers:
    - GANDI LiveDNS API
    - OVH API

## I/ Pre-requisites

This part describes the different pre-requisites to meet in order to use this module.

### API Token / Credentials

You will need to create an API Token, or generate credential in order to use the API of your provider.
Also, and as a security warning, make sure (if possible) to limit the scope of your token / credentials only to retrieve / update DNS records information.

### OS Requirements by type

There may be some pre-requisites, depending on your environment.

- For **MacOS** systems

Install Homebrew by using the comment `/bin/bash -c "$(curl -fsSL raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
Install JQ package with `brew install jq`
Install md5sha1sum with `brew install md5sha1sum`

- For **Debian/Ubuntu-based** systems

Update your system with `sudo apt-get update`
Install JQ package with `sudo apt-get install jq`

- For **Fedora/RHEL-based** systems

Install JQ package with `sudo dnf install jq`

- For **Windows** systems

Please use WSL with windows, in order to use this script.
https://learn.microsoft.com/fr-fr/windows/wsl/install

## II/ Initialization

Initialize the script by running the command `./DNS_autoupdater.sh --setup`.
The script will ask you a set of question in order to easily setup your environment.

## III/ Usage

Run the script with:

`./DNS_autoupdater.sh`