# DNS_autoupdater

This Bash script can be used to automatically update an A or AAAA type DNS record depending of your current public IP.

**Usecase** You need to access a firewall protected environment, and a DNS record has been setup so that your firewall can dynamically resolve and allow the IP address behing your record.

Currently supports the following DNS providers:
    - GANDI LiveDNS API

## I/ Pre-requisites

There may be some pre-requisites, depending on your environment.

### OS Requirements by type

- For **MacOS** systems

Install Homebrew by using the comment `/bin/bash -c "$(curl -fsSL raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
Install JQ package with `brew install jq`

- For **Debian/Ubuntu-based** systems

Update your system with `sudo apt-get update`
Install JQ package with `sudo apt-get install jq`

- For **Fedora/RHEL-based** systems

Install JQ package with `sudo dnf install jq`

- For **Windows** systems

Not supported at the moment.

## II/ Initialization

Coming soon.

## III/ Usage

Run the script with:

`./DNS_autoupdater.sh`

## IV/ Usage