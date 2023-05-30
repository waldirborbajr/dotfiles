# For Pop!_OS 22.04 or higher:
sudo apt reinstall --purge bluez gnome-bluetooth
sudo apt install blueman
sudo apt install bluetooth bluez bluez-tools

# wifi
sudo apt install git build-essential dkms
sudo apt install broadcom-sta-dkms

# For Pop!_OS 21.10 or 20.04:
# sudo apt install --reinstall bluez gnome-bluetooth indicator-bluetooth pulseaudio-module-bluetooth


# ----- WIFI

sudo lshw -C network
sudo apt remove broadcom-sta-dkms bcmwl-kernel-source
sudo apt install firmware-b43-installer
