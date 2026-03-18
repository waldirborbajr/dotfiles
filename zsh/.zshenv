#!/usr/bin/env zsh

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Secrets
#[ -f "$HOME/.env" ] && source "$HOME/.env"

# Set up relevant XDG base directories.
# Spec: https://specifications.freedesktop.org/basedir-spec/latest/index.html
# ------------------------------------------------------------------------------
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Make sure directories actually exist
#xdg_base_dirs=("$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME")
#for dir in "${xdg_base_dirs[@]}"; do
#  if [[ ! -d "$dir" ]]; then
#    mkdir -p "$dir"
#  fi
#done

# Set ZDOTDIR here. All other Zsh related configuration happens there.
# ------------------------------------------------------------------------------
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# Set up default editor
# ------------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim

# History (must be here so it applies everywhere)
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# Locale settings
#export LANG="en_US.UTF-8" # Sets default locale for all categories
#export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
#export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Hide computer name in terminal
export DEFAULT_USER="$(whoami)"
