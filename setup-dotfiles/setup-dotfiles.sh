#!/bin/bash

if ! [ -x "$(command -v git)" ]; then
  if [ -x "$(command -v apt-get)" ]; then
    apt-get update
    apt-get install git -y
  fi
  if ! [ -x "$(command -v git)" ]; then
    printf "\nThis script requires git!\n"
    exit 1
  fi
fi

# git clone https://github.com/waldirborbajr/dotfiles.git ~/dotfiles

symblink() {
  if [ -e ~/$1 ]; then
    echo "Found existing file, created backup: ~/${1}.bak"
    mv ~/$1 ~/$1.bak
  fi
  ln -sf ~/dotfiles/$1 ~/$1;
}

symblink .config/alacritty
symblink .config/bat
symblink .config/htop
# symblink .config/nvim
symblink .config/peco
symblink .config/tealdeer
symblink .config/zellij
symblink .config/starship
symblink .config/helix

symblink .zshrc
symblink .zshenv
symblink alias.generic.zsh
symblink alias.git.zsh

symblink .gitconfig
# symblink .gitignore
symblink .curlrc

symblink .ripgreprc

symblink rustfmt
symblink bin

# symblink .gitcompletion.bash
# symblink .kubecompletion.bash
# symblink .nvmrc
# symblink .hyper.js
# symblink .tmux.conf
# symblink .XCompose
# symblink .bash_aliases
# symblink .bash_prompt
# symblink .inputrc

# symblink .emacs

# echo "Enter Git fullname:"
# read GIT_FULLNAME
# echo "Requesting root permissions to set git config at system level..."
# sudo git config --system user.name $GIT_FULLNAME
# echo "Success."

# echo "Enter Git email address:"
# read GIT_EMAIL
# echo "Requesting root permissions to set git config at system level..."
# sudo git config --system user.email $GIT_EMAIL
# echo "Success."

# exec $BASH
