#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi


apt install -y --no-install-recommends alsa-utils bluez-tools

# Install bluealsa
# Install Dependencies
apt install -y --no-install-recommends pkg-config libtool libglib2.0-dev libdbus-1-dev bluez libbluetooth-dev libspandsp-dev libasound2 libasound2-dev alsa-tools libsbc-dev git automake build-essential python3-docutils
# Install Codecs
apt install -y --no-install-recommends libopenaptx-dev libfdk-aac-dev libdbus-1-3

cd ..
git clone https://github.com/ancodi/bluez-alsa.git
cd bluez-alsa
autoreconf --install --force
mkdir build
cd build
 ../configure --enable-aac --enable-aptx --with-libopenaptx --enable-cli --enable-a2dpconf --disable-payloadcheck  --enable-manpages --enable-systemd --with-systemdbluealsaargs="-p a2dp-sink -c aptx" --enable-msbc --with-systemdbluealsaaplayargs="--mixer-name=FM"
make
sudo make install
cd ..
# Bluetooth settings
cat <<'EOF' > /etc/bluetooth/main.conf
[General]
Class = 0x200414
DiscoverableTimeout = 0
[Policy]
AutoEnable=true
EOF

# Bluetooth PIN / Password protection

echo
echo "Exposing Bluetooth without a PIN comes with risks."
echo "You are therefore now asked to setup a PIN for connecting new devices."
read -p "What PIN do you want to use? " BT_PIN

cat <<EOF > /home/pi/pins
* ${BT_PIN}
EOF
  echo;
  echo -n "Your Bluetooth PIN is: ${BT_PIN}";
  echo;



# Make Bluetooth discoverable after initialisation
mkdir -p /etc/systemd/system/bthelper@.service.d
cat <<'EOF' > /etc/systemd/system/bthelper@.service.d/override.conf
[Service]
Type=oneshot
EOF

cat <<'EOF' > /etc/systemd/system/bt-agent@.service
[Unit]
Description=Bluetooth Agent
Requires=bluetooth.service
After=bluetooth.service
[Service]
ExecStartPre=/usr/bin/bluetoothctl discoverable on
ExecStartPre=/bin/hciconfig %I piscan
#ExecStartPre=/bin/hciconfig %I sspmode 0
ExecStart=/usr/bin/bt-agent --capability=DisplayOnly -p /home/pi/pins
RestartSec=5
Restart=always
KillSignal=SIGUSR1
[Install]
WantedBy=multi-user.target
EOF
systemctl enable bt-agent@hci0.service

# ALSA settings
# sed -i.orig 's/^options snd-usb-audio index=-2$/#options snd-usb-audio index=-2/' /lib/modprobe.d/aliases.conf

# BlueALSA
mkdir -p /etc/systemd/system/bluealsa.service.d
cat <<'EOF' > /etc/systemd/system/bluealsa.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/bluealsa -p a2dp-sink -c aptx
RestartSec=5
Restart=always
EOF

cat <<'EOF' > /etc/systemd/system/bluealsa-aplay.service
[Unit]
Description=BlueALSA aplay
Requires=bluealsa.service
After=bluealsa.service sound.target
[Service]
Type=simple
User=root
ExecStartPre=/bin/sleep 2
ExecStart=/usr/bin/bluealsa-aplay --mixer-name=FM
RestartSec=5
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable bluealsa-aplay

# Bluetooth udev script
cat <<'EOF' > /usr/local/bin/bluetooth-udev
#!/bin/bash
if [[ ! $NAME =~ ^\"([0-9A-F]{2}[:-]){5}([0-9A-F]{2})\"$ ]]; then exit 0; fi
action=$(expr "$ACTION" : "\([a-zA-Z]\+\).*")
if [ "$action" = "add" ]; then
    bluetoothctl discoverable off
    # disconnect wifi to prevent dropouts
    #ifconfig wlan0 down &
fi
if [ "$action" = "remove" ]; then
    # reenable wifi
    #ifconfig wlan0 up &
    bluetoothctl discoverable on
fi
EOF
chmod 755 /usr/local/bin/bluetooth-udev

cat <<'EOF' > /etc/udev/rules.d/99-bluetooth-udev.rules
SUBSYSTEM=="input", GROUP="input", MODE="0660"
KERNEL=="input[0-9]*", RUN+="/usr/local/bin/bluetooth-udev"
EOF
