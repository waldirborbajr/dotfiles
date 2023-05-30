#!/usr/bin/env bash

set -e
set -o pipefail

ssh-keygen -t ed25519 -b 32768 -C "$(hostname)($(uname -o))"

function copy:key {

  if [ -z "${1}" ]; then
    echo "please inform target server as user@ip_address"
    exit -1
  fi

  ssh-copy-id -i ~/.ssh/id_ed25519.pub $1
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"


