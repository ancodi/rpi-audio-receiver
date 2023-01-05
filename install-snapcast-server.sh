#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo
echo -n "Do you want to install Snapserver? [Y/n] "
read REPLY
if [[ "$REPLY" =~ ^(no|n|N)$ ]]; then exit 0; fi

# Install Snapcast from .deb
wget -q https://github.com/badaix/snapcast/releases/download/v0.26.0/snapserver_0.26.0-1_armhf.deb
apt install -y --no-install-recommends ./snapserver_0.26.0-1_armhf.deb

# Setup Snapserver listening channels

source = pipe:///tmp/snapfifo?name=default
sed -i '/source = pipe:///tmp/snapfifo?name=default/source = pipe:///tmp/snapfifo?name=Bluetooth Audio' /etc/snapserver.conf
sed -i '/\[stream\]/a source = pipe:///tmp/librespotfifo?name=Spotify Connect]' /etc/snapserver.conf


# ALSA Setup for piping bluealsa-aplay output to snapfifo

echo "fs.protected_fifos = 0" | sudo tee /etc/sysctl.d/snapcast-unprotect-fifo.conf

cat <<EOF > /etc/asound.conf
pcm.!default {
    type plug
    slave.pcm rate48000Hz
}

pcm.rate48000Hz {
    type rate
    slave {
        pcm writeFile # Direct to the plugin which will write to a file
        format S16_LE
        rate 48000
    }
}

pcm.writeFile {
    type file
    slave.pcm null
    file "/tmp/snapfifo"
    format "raw"
}
EOF

# Unmute Bluealsa PCM
# PCM_PATH_MUTED = $(bluealsa-cli list-pcms)
# bluealsa-cli mute ${PCM_PATH_MUTED} 0 0
