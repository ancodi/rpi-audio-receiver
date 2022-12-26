#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo
echo -n "Do you want to install Snapserver? [Y/n] "
read REPLY
if [[ "$REPLY" =~ ^(no|n|N)$ ]]; then exit 0; fi

# Install Snapcast from .deb
wget https://github.com/badaix/snapcast/releases/download/v0.26.0/snapserver_0.26.0-1_armhf.deb

# apt install -y --no-install-recommends snapserver

# Snapserver listening options
sed -i '/\[stream\]/a alsa://?name=<name>&device=hw:0,0[&send_silence=false][&idle_threshold=100][&silence_threshold_percent=0.0]' /etc/snapserver.conf
