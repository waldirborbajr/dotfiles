#!/usr/bin/env bash

myhostname=`hostname`

[[ "${1}" ]] && myhostname=${1}

sudo hostnamectl set-hostname ${myhostname}
sudo update-locale LANG=en_US.UTF-8
#
# sudo system76-power graphics hybrid

# Nix
#sh <(curl -L https://nixos.org/nix/install) --daemon

# NGROK
#curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list

#AnyDesk
wget -O- https://keys.anydesk.com/repos/DEB-GPG-KEY |\
    gpg --dearmor |\
    sudo tee /usr/share/keyrings/anydesk.gpg > /dev/null
sudo echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list

# Nala
# echo "deb http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
# wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null

#sudo apt update && sudo apt install nala -y
#
sudo nala update
sudo nala upgrade -y
sudo nala autoremove -y
sudo nala autopurge -y
#
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update
#

echo " "
echo "-------------------------------------------------------- "
echo " "
echo "Wait, running install packages now. Relax and take a coffee"
echo " "
echo "-------------------------------------------------------- "
echo " "

INSTALL=(
    anydesk
    apt-transport-https
    htop
#    ngrok
#    mesa-utils
#    libnss3-tools
    lm-sensors
#    screenkey
    bc
    peco
#    podman
   exa
#    bat
    fzf
#    acpi
    libssl-dev
    fonts-powerline
    ca-certificates
    curl
    git
    git-lfs
    gnupg
    lsb-release
    ripgrep
    wget
    zsh
#    tmux
    libtool
    libtool-bin
    autoconf
    automake
    cmake
    g++
    pkg-config
    unzip
    openconnect
 #   network-manager-openconnect
 #   network-manager-openconnect-gnome
    openvpn
    build-essential
#    vlc
    libavcodec-extra
    libdvd-pkg
#    obs-studio
#    software-properties-common
#    libxml2-dev
#    libpam0g-dev
#    libudisks2-dev
#    libglib2.0-dev
#    gir1.2-udisks-2.0
#    python3
#    python3-gi
#    discord
#    gridsite-clients
    lynx
)

for pkg in "${INSTALL[@]}"; do
    sh -c "sudo nala install -y $pkg" "$pkg"
done

sudo dpkg-reconfigure libdvd-pkg

# -- Flatpak
echo " "
echo "-----------------------------------"
echo "Configuring Flatpak"
echo "-----------------------------------"
echo " "
#flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#flatpak update
#flatpak install flathub com.spotify.Client -y
#flatpak install flathub io.github.mimbrero.WhatsAppDesktop -y

echo " "
echo "-----------------------------------"
echo "That's all folks"
echo " "
echo " Reboot and be happy"
echo "-----------------------------------"
echo " "
