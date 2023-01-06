## BananaPi Multiroom Audio Server - Based on the Github Repo of Raspberry Pi Audio Reciever Project from Arcadia197 with a lot of modification

A simple, light weight Multiroom Audio server running Snapcast which plays from Bluetooth (A2DP) and Spotify Connect (right now).
Repo this is based on can be found [here](github.com/Arcadia197/rpi-audio-receiver).

## Features

Devices like phones, tablets and computers can play audio via this receiver.

## Requirements

- A USB Bluetooth dongle (the internal Raspberry Pi Bluetooth chipset turned out as not suited for audio playback and causes all kinds of strange connectivity problems)
- BananaPi M1 with [Armbian Bullseye 22.11](https://www.armbian.com/bananapi/)
- Ethernet connection to BananaPi

## Installation

The installation script asks whether to install each component.

    wget -q https://github.com/ancodi/rpi-audio-receiver/archive/rpi-zero-w.zip
    unzip rpi-zero-w.zip
    rm rpi-zero-w.zip

    cd rpi-audio-receiver-rpi-zero-w
    sudo ./install.sh
    
All effects should come into play after restarting the device.

## ALL BELOW NEED UPDATE
### Basic setup

Lets you choose the hostname and the visible device name ("pretty hostname") which is displayed as Bluetooth name, in AirPlay clients and in Spotify.

### Bluetooth

Sets up Bluetooth, adds a simple agent that accepts every connection, and enables audio playback through Alsa (via BlueAlsa). A udev script is installed that disables discoverability while connected.

### AirPlay

Installs [Shairport Sync](https://github.com/mikebrady/shairport-sync) AirPlay Audio Receiver.

### Spotify Connect

Installs a working version of [Raspotify](https://github.com/dtcooper/raspotify), an open source Spotify client for Raspberry Pi. The version 0.31.4  was the last version working without troubles with the RPi zero w. More information can be found in [this issue](https://github.com/dtcooper/raspotify/issues/504), especially [this comment](https://github.com/dtcooper/raspotify/issues/504#issuecomment-1022760874)

### Snapcast client

Installs [Snapclient](https://github.com/badaix/snapcast), the client component of the Snapcast Synchronous multi-room audio player.

## Wiki

There are some further examples, tweaks and how-tos in the [GitHub Wiki](https://github.com/Arcadia197/rpi-audio-receiver/wiki) or the [wiki of the original repo](github.com/nicokaiser/rpi-audio-receiver/wiki).

## Disclaimer

These scripts are tested and work on a current Raspberry Pi OS Legacy setup on Raspberry Pi Zero W 1. Depending on your setup (board, configuration, sound module, Bluetooth adapter) and your preferences, you might need to adjust the scripts. They are held as simple as possible and can be used as a starting point for additional adjustments.

## Upgrading

This project does not really support upgrading to newer versions of this script. It is meant to be adjusted to your needs and run on a clean Raspberry Pi OS install. When something goes wrong, the easiest way is to just wipe the SD card and start over. Since apart from Bluetooth pairing information all parts are stateless, this should be ok.

Updating the system using `apt-get upgrade` should work however.

## Uninstallation

This project does not support uninstall at all. As stated above, it is meant to run on a dedicated device on a clean Raspberry Pi OS. If you choose to use this script along with other services on the same device, or install it on an already configured device, this can lead to unpredictable behaviour and can damage the existing installation permanently.
However, the important modules can be purged with the following commands. This does however not remove residual files and is experimental:

    sudo apt-get purge raspotify shairport-sync snapclient
    sudo systemctl disable bthelper@hci0.service bt-agent@hci0.service
    sudo systemctl stop bthelper@hci0.service bt-agent@hci0.service

[This site](https://github.com/mikebrady/shairport-sync/blob/master/INSTALL.md) gives information on residual files of shairplay which could be checked for removal.


## Contributing

Package and configuration choices are quite opinionated but as close to the Debian defaults as possible. Customizations can be made by modifying the scripts, but the installer should stay as simple as possible, with as few choices as possible. That said, pull requests and suggestions are of course always welcome. However I might decide not to merge changes that add too much complexity.

## References

- [Shairport Sync: AirPlay Audio Receiver](https://github.com/mikebrady/shairport-sync)
- [Raspotify: Spotify Connect client for the Raspberry Pi that Just Works™](https://github.com/dtcooper/raspotify)
- [Snapcast: Synchronous audio player](https://github.com/badaix/snapcast)

## License

[MIT](LICENSE)
