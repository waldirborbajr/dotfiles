# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias '?'=searchOnDuck
alias '??'=searchOnGoogle

alias v=nvim
alias vi=nvim
alias rmvim="rm -rf ~/.local/share/nvim && rm -rf ~/.cache/nvim && rm -rf ~/.local/state/nvim"

alias r=reset

# Cargo
# cargo install cargo-cache
# cargo install cargo-update
alias cr='cargo run --'
alias ccr='clear && cr'
alias cargo-install='cargo install --path .'
alias cargo-upgrade='cargo install-update -a'
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') --force"
alias cargofullcache="cargo-cache -r all"
alias cargocache="cargo cache -a"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

alias cleanapt="df -h && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && df -h"

# Rebinding
alias ls='eza -a --icons'
alias cat='bat'

# Find Files
alias ff="rg --files | sk --preview='bat {} --color=always'"

## Zellij
alias zj="zellij a -c 'B+ DevOps'"
alias zjrust="zellij --layout $HOME/.config/zellij/zelliRUST.kdl a -c 'B+ DevRust'"
alias zjgo="zellij --layout $HOME/.config/zellij/zelliGO.kdl a -c 'B+ DeviGO'"
alias zka="zellij ka -y"
alias zrn="zellij r -- $1"

export OPT_PATH=/opt
export CHROME_EXECUTABLE=/snap/bin/chromium
# export FLUTTER_HOME=/opt/flutter
# export ANDROID_STUDIO=/opt/android-studio
export GOPATH=/usr/local/go
export GOBIN=/home/borba/go
# export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export LOCALBIN=$HOME/.local/bin

# export PATH=$PATH:$ANDROID_STUDIO/bin:$FLUTTER_HOME/bin:$OPT_PATH/bin:$GOPATH/bin:$GOBIN/bin:$DOCKER_CONFIG/cli-plugins
export PATH=$PATH:$OPT_PATH/bin:$GOPATH/bin:$GOBIN/bin:$LOCALBIN

# used at docker-compose to avoid create volume as root
export UID=$(id -u)
export GID=$(id -g)
export DOCKER_HOST=unix:///run/user/1000/docker.sock

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

function createVenv(){
  # dest="${PWD##*/}"
  dest="$1"

  if python3 -m venv "$dest" ; then
    cd "$dest"
    source "./bin/activate"
    [ ! -f "./requirements.txt" ] || pip install -r requirements.txt
  else
     echo "Failed to create 'venv' environment" >&2
  fi
}

# Download and Instlal GO
getgo(){
  version="$1"
  wget https://go.dev/dl/go${version}.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz
}

# Clean system.
clean-system () {
	rm -rf ~/.cache
}

# Restart a program.
refresh () {
	killall $1
	$1 &
}

eval "$(starship init zsh)"
