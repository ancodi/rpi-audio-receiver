#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

read -p "Set Hostname [$(hostname)]: " HOSTNAME
hostnamectl set-hostname ${HOSTNAME:-$(hostname)}

CURRENT_PRETTY_HOSTNAME=$(hostnamectl status --pretty)
read -p "Pretty hostname [${CURRENT_PRETTY_HOSTNAME}]: " PRETTY_HOSTNAME
hostnamectl set-hostname --pretty "${PRETTY_HOSTNAME:-${CURRENT_PRETTY_HOSTNAME}}"

echo "Updating packages"
apt update
apt upgrade -y

echo "Installing components"
./install-bluetooth.sh
./install-shairport.sh
./install-spotify.sh
#./install-snapcast-client.sh
#./install-snapcast-server.sh
#./enable-hifiberry.sh
