# Path to your oh-my-zsh installation.
export ZSH="/Users/borba/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

plugins=(
  git
  wd
  docker
  docker-compose
  zsh-autosuggestions
  zsh-completions
  osx
  colorize
  golang
  emoji
  vi-mode
  zsh-syntax-highlighting
)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias bz="nvim ~/.zshrc"
alias ws="cd /Volumes/BPlus/Workspaces/ "

# Python
alias ce='python -m venv ./venv'
alias ae='deactivate &> /dev/null; source ./venv/bin/activate'
alias de='deactivate'

alias v='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh

# prevent sharing shell history between different windows (enabled by default in OMZ)
unsetopt share_history

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -f /usr/local/bin/screenfetch ]; then screenfetch; fi

# export LATEX=/usr/local/texlive/2021/bin/x86_64-darwin
export LATEX=/usr/local/texlive/2021/bin/x86_64-darwinlegacy
export MANPATH=$MANPATH:/usr/local/texlive/2021/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/usr/local/texlive/2021/texmf-dist/doc/info

export GOBIN=$HOME/go/bin
export FLUTTER=/usr/local/flutter/bin
# export GOPATH=/usr/local/go
export PATH=$PATH:$LATEX:$GOBIN:$FLUTTER


export PATH="$HOME/.poetry/bin:$PATH"
