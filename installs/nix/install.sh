#!/usr/bin/env bash

set -e
set -o pipefail

NIX=/nix/var/nix/profiles/default/bin/nix
[[ ! -f ${NIX} ]] && sh <(curl -L https://nixos.org/nix/install) --daemon

nix-env -iA \
  nixpkgs.tealdeer \
  nixpkgs.exa \
  nixpkgs.helix \
  nixpkgs.bat \
  nixpkgs.fzf \
  nixpkgs.ripgrep

