#!/usr/bin/env bash

myhostname=`hostname`

[[ "${1}" ]] && myhostname=${1}

sudo hostnamectl set-hostname ${myhostname}
sudo update-locale LANG=en_US.UTF-8


../golang/installGO.sh 1.20.4 linux
../rust/install.sh
# ../linux/install.sh
#../nix/install.sh
../zsh/install.sh
#../tmux/install.sh
../alacritty/install.sh
../nvim/install.sh
../zellij/install.sh
../zoxide/install.sh
#../tealdeer/install.sh
../nerdfont/install.sh 3.0.1
../zsh/installOHMY.sh

