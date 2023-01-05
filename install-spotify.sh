#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo
echo -n "Do you want to install Spotify Connect (Raspotify)? [y/N] "
read REPLY
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then exit 0; fi

#wget -q https://github.com/dtcooper/raspotify/releases/download/0.31.4/raspotify_0.31.4.librespot.v0.3.1-34-ge5fd7d6_armhf.deb
#dpkg -i raspotify_0.31.4.librespot.v0.3.1-34-ge5fd7d6_armhf.deb
apt install -y --no-install-recommends libpulse0
apt install -y --no-install-recommends curl && curl -sL https://dtcooper.github.io/raspotify/install.sh | sh

#PRETTY_HOSTNAME=$(hostnamectl status --pretty | tr ' ' '-')
#PRETTY_HOSTNAME=${PRETTY_HOSTNAME:-$(hostname)}

# change settings to work for raspberry pi zero
# sed -i 's:#LIBRESPOT_FORMAT="S16":LIBRESPOT_FORMAT="S32"' /etc/raspotify/conf


# sed -i 's:LIBRESPOT_ENABLE_VOLUME_NORMALISATION=:#LIBRESPOT_ENABLE_VOLUME_NORMALISATION=:' /etc/raspotify/conf
# sed -i 's:#LIBRESPOT_NAME="Librespot:LIBRESPOT_NAME="'"${PRETTY_HOSTNAME}"':' /etc/raspotify/conf
# sed -i 's:#LIBRESPOT_BITRATE="160":LIBRESPOT_BITRATE="320":' /etc/raspotify/conf
# sed -i 's:#LIBRESPOT_DEVICE_TYPE:LIBRESPOT_DEVICE_TYPE:' /etc/raspotify/conf
# sed -i 's:#LIBRESPOT_INITIAL_VOLUME="50":LIBRESPOT_INITIAL_VOLUME="20":' /etc/raspotify/conf
# sed -i 's:#LIBRESPOT_VOLUME_CTRL="log":LIBRESPOT_VOLUME_CTRL="cubic":' /etc/raspotify/conf

systemctl restart raspotify
