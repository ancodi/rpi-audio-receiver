#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

read -p "Set Hostname [$(hostname)]: " HOSTNAME
hostnamectl set-hostname ${HOSTNAME:-$(hostname)}

echo "Updating packages"
apt update
apt upgrade -y

echo "Installing components"
./install-bluetooth.sh
./install-shairport.sh
./install-spotify.sh
#./install-snapcast-client.sh
#./enable-hifiberry.sh
