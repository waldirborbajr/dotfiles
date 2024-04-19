#
# ███████╗███████╗██╗  ██╗██████╗  ██████╗
# ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#   ███╔╝ ███████╗███████║██████╔╝██║
#  ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
# ZSH Config File by Waldir Borba Junior

source "$ZDOTDIR/env.zsh"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  echo "Installing zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
  echo "Installing zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting rust docker golang)

source $ZSH/oh-my-zsh.sh

source "$HOME/.cargo/env"

if [ -e /home/borba/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/borba/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer

# source
# . "$ZSH/oh-my-zsh.sh"
. "$ZDOTDIR/functions.zsh"
. "$ZDOTDIR/options.zsh"
. "$ZDOTDIR/completions.zsh"
. "$ZDOTDIR/fzf.zsh"
. "$ZDOTDIR/node.zsh"
. "$ZDOTDIR/aliases.zsh"
. "$ZDOTDIR/plugins.zsh"
. "$ZDOTDIR/starship.zsh"
. "$ZDOTDIR/zoxide.zsh"

export PATH=$PATH:$HOME/scripts/
