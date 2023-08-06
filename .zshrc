export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

# Which plugins would you like to load?
plugins=(
  # git
  z
  wd
  fast-syntax-highlighting
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  # zsh-peco-history
  # tmux
	command-not-found
	# dotenv
  # web-search
  fzf
)

source $ZSH/oh-my-zsh.sh

# Exports
export USER="${USER:-$(whoami)}"
export GITUSER="$USER"
export VISUAL='nvim'
export EDITOR=$VISUAL
export GNUTERM="sixelgd size 1600,300 truecolor font arial 16"
export TERM="xterm-256color"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
# export TERM=screen-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
# export TINYGO=/usr/local/tinygo
# export SCRIPTS=$HOME/.config/scripts
# export SNAP=/snap
#
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
export PATH=$PATH:$HOME/.local/share/nvim/lspinstall/lua-language-server/bin/
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin
# -- Flutter / Dart
export PATH="$PATH:/opt/flutter/bin"
CHROME_EXECUTABLE=/snap/bin/chromium
export CHROME_EXECUTABLE
export PATH=$PATH:/opt/android-studio/bin
# Settings
export HISTCONTROL="ignorespace"
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export VISUAL=vim
export EDITOR=nvim
export FZF_DEFAULT_OPTS=--reverse
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:-1,bg:-1,fg+:-1,bg+:-1,hl+:4,hl:4
    --color=spinner:-1,info:-1,prompt:-1,pointer:1'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Peco config
ZSH_PECO_HISTORY_OPTS="--layout=bottom-up --initial-filter=Fuzzy"

# Do not save ZSH duplicate history
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt share_history
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY # append into history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS  ## Delete empty lines from history file
setopt HIST_NO_STORE  ## Do not add history and fc commands to the history
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

source $HOME/alias.generic.zsh

#------- NVIM -------
#--------------------
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^\\ "nvims\n"
#------- NVIM -------
#--------------------

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/borba/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
