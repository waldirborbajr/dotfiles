#!/bin/bash
export ZSH="$XDG_CONFIG_HOME/zsh/.oh-my-zsh"
export ZSHZ_DATA="${XDG_CONFIG_HOME:-$HOME/.config}/z/.z"

# PATH
export DOTFILES="$HOME/dotfiles"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8

export OPT_PATH=/opt
export CHROME_EXECUTABLE=/snap/bin/chromium
# export FLUTTER_HOME=/opt/flutter
# export ANDROID_STUDIO=/opt/android-studio

export GOROOT=/usr/local/go
export GOPATH=$HOME/go   # your-go-workspace
export GOBIN=$GOPATH/bin # where go-generate-executable-binaries

# export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export LOCALBIN=$HOME/.local/bin
# export CARGOBIN=$HOME/.cargo/bin
export BINS=$HOME/scripts

# export PATH=$PATH:$ANDROID_STUDIO/bin:$FLUTTER_HOME/bin:$OPT_PATH/bin:$GOPATH/bin:$GOBIN/bin:$DOCKER_CONFIG/cli-plugins
export PATH=$PATH:$OPT_PATH/bin:$GOPATH/bin:$GOBIN:$LOCALBIN:$CARGOBIN:$BINS

# used at docker-compose to avoid create volume as root
export UID=$(id -u)
export GID=$(id -g)
# export DOCKER_HOST=unix:///run/user/1000/docker.sock

# Rust debug for tracing and other logging
export RUST_LOG=debug
