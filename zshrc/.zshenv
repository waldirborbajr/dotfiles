# Environment variables
. "/home/borba/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Only source this once
if [[ -z "$__HM_ZSH_SESS_VARS_SOURCED" ]]; then
  export __HM_ZSH_SESS_VARS_SOURCED=1
  export DIRENV_LOG_FORMAT=""
export LC_ALL="en_US.UTF-8"
export NIXPKGS_ALLOW_UNFREE="1"
export TERM="xterm-256color"
fi

export ZDOTDIR=$HOME/.config/zsh
