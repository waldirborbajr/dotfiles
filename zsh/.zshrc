# Use viins keymap as the default.
bindkey -v

TZ="America/Sao_Paulo"
ZSH_AUTOSUGGEST_STRATEGY=("history" "completion")
ZVM_VI_INSERT_ESCAPE_BINDKEY="jk"
# Load Zsh modules
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

# Initialize colors
autoload -Uz colors
colors

# Initialize completion system
autoload -U compinit
compinit
_comp_options+=(globdots)

# Load edit-command-line for ZLE
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

# General completion behavior
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Complete the alias
zstyle ':completion:*' complete true

# Autocomplete options
zstyle ':completion:*' complete-options true

# Completion matching control
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true

# Group matches and describe
zstyle ':completion:*' menu select
zstyle ':completion:*' list-grouped false
zstyle ':completion:*' list-separator ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '[%d]'

# Colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Sort
zstyle ':completion:*' sort false
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:eza' sort false
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:files' sort false

# fzf-tab
zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview $realpath'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:*' fzf-min-height 100
zstyle ':fzf-tab:*' switch-group ',' '.'

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="536870912"
SAVEHIST="536870912"
HISTORY_IGNORE='(*.private*)'
HISTFILE="/home/borba/.cache/zsh/zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt autocd

# export ANDROID_SDK_ROOT=$HOME/development/Android/Sdk/
# export ANDROID_HOME=$HOME/development/Android/Sdk/
# export PATH=$ANDROID_SDK_ROOT/tools:$PATH
# export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH
# export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
# export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
# export CHROME_EXECUTABLE=/home/borba/.nix-profile/bin/chromium
# export CHROME_EXECUTABLE=/snap/bin/chromium

export GOPATH=$(mise exec go --command 'go env GOPATH')
export GOROOT=$(mise exec go --command 'go env GOROOT')
export GOBIN=$(mise exec go --command 'go env GOBIN')
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$HOME/.local/bin

function cd() {
  builtin cd $*
  lsd
}

function mkd() {
  mkdir $1
  builtin cd $1
}

function _list_zellij_sessions () {
  zellij list-sessions 2>/dev/null | sed -e 's/\x1b\[[0-9;]*m//g'
}

function zja() {
  zj_session=$(_list_zellij_sessions | rg -v '(EXITED -|\(current\))' | awk '{print $1}' | fzf)
  if [[ -n $zj_session ]]; then
    wezterm start -- zsh --login -c "zellij attach $session"
  fi
}

function zjl() {
  layout=$(fd '.*' "$HOME/.config/zellij/layouts" | xargs -I{} basename {} .kdl | fzf)
  if [[ -n $layout ]]; then
    wezterm start -- zsh --login -c "zellij --layout $layout attach -c $layout"
  fi
}

function zjgc() {
  sessions=$(_list_zellij_sessions | awk '/EXITED -/ {print $1}' )
  if [[ -n $sessions ]]; then
    echo $sessions | xargs -n1 zellij d
  fi
}

function zjd() {
  sessions=$(_list_zellij_sessions | awk '{print $1}' | fzf -m)
  if [[ -n $sessions ]]; then
    echo $sessions | xargs -n1 zellij d --force
  fi
}

function chirpinstall() {

  URL="$1"

  FILENAME=$(basename "$URL")

  cd $HOME/Downloads/
  
  curl -O $URL
  pipx install --system-site-packages --force $FILENAME
}

function ghpr() {
  GH_FORCE_TTY=100% gh pr list | fzf --ansi --preview 'GH_FORCE_TTY=100% gh pr view {1}' --preview-window down --header-lines 3 | awk '{print $1}' | xargs gh pr checkout
}

function fletnew() {

  if [[ -z  "$1" ]]; then
    exit 1;
  fi

  mkdir $1
  cd $1
  uv init --bare
  uv add 'flet[all]' --dev
  uv run flet create
  source .venv/bin/activate
}

function fleton() {
  source .venv/bin/activate
}

function fletoff() {
  deactivate
}

# # Starship initialization
# eval "($starship init zsh)"
# eval "$(/nix/store/8z0s76z97izq0idblkyx42n8466qh05q-starship-1.22.1/bin/starship init zsh)"

# Zoxide initialization
# eval "($zoxide init zsh)"

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if [[ $TERM != "dumb" ]]; then
  eval "$(/nix/store/8z0s76z97izq0idblkyx42n8466qh05q-starship-1.22.1/bin/starship init zsh)"
fi

eval "$(/nix/store/pj26znmd6gw4gpiqfgn9z5y7zz6vhj24-direnv-2.35.0/bin/direnv hook zsh)"

alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
alias -- aq='asciiquarium -s'
alias -- d=docker
alias -- da='docker ps -a'
alias -- de='docker exec -it'
alias -- di='docker images'
alias -- docker_clean='docker builder prune -a --force'
alias -- dr='docker run --rm -it'
alias -- drma='docker stop $(docker ps -aq) && docker rm -f $(docker ps -aq)'
alias -- drmc='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
alias -- drmd='docker rmi $(docker images -a --filter=dangling=true -q)'
alias -- drmi='di | grep none | awk '\''{print $3}'\'' | sponge | xargs docker rmi'
alias -- drmii='docker rmi $(docker images -a -q)'
alias -- eza='eza --icons auto --git'
alias -- ff=fastfetch
alias -- gg=lazygit
alias -- k=kubectl
alias -- kdd='kubectl describe deployment'
alias -- kdeld='kubectl delete deployment'
alias -- kdeli='kubectl delete ingress'
alias -- kdelns='kubectl delete namespace'
alias -- kdelp='kubectl delete pods'
alias -- kdels='kubectl delete svc'
alias -- kdelsec='kubectl delete secret'
alias -- kdi='kubectl describe ingress'
alias -- kdno='kubectl describe node'
alias -- kdns='kubectl describe namespace'
alias -- kdp='kubectl describe pods'
alias -- kds='kubectl describe svc'
alias -- kdsec='kubectl describe secret'
alias -- ked='kubectl edit deployment'
alias -- kei='kubectl edit ingress'
alias -- kens='kubectl edit namespace'
alias -- kep='kubectl edit pods'
alias -- kes='kubectl edit svc'
alias -- kgd='kubectl get deployment'
alias -- kgi='kubectl get ingress'
alias -- kgno='kubectl get node'
alias -- kgns='kubectl get namespaces'
alias -- kgp='kubectl get pods'
alias -- kgs='kubectl get svc'
alias -- kgsec='kubectl get secret'
alias -- l='ls -l'
alias -- la='ls -a'
alias -- ld=lazydocker
alias -- lg=lazygit
alias -- ll='eza -l'
alias -- lla='ls -la'
alias -- ls=lsd
alias -- lt='ls --tree'
alias -- repo='cd $HOME/Documents/repositories'
alias -- rmvim='rm -rf ~/.local/share/nvim && rm -rf ~/.cache/nvim && rm -rf ~/.local/state/nvim'
alias -- syshealth='sudo nala update && sudo rm /var/lib/apt/lists/lock && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean && flatpak update -y && flatpak uninstall --unused -y && sudo snap refresh'
alias -- temp='cd $HOME/Downloads/temp'
alias -- tmc='clear; tmux clear-history; clear'
alias -- tmk='tmux kill-session'
alias -- v=nvim
alias -- vi=nvim
alias -- vim=nvim
alias -- xterm='sudo update-alternatives --config x-terminal-emulator'
alias -- y=yazi
alias -- zj='zellij a -c '\''B+ DevOps'\'''
alias -- zlcahe='rm -rf ~/.cache/zellij'
