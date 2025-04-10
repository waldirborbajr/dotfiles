#!/usr/bin/env zsh

check_command() {
  if ! command -v $1 >/dev/null 2>&1; then
    echo "👻 command '$1' does not exist. Please install it first. $2"
    return 1
  fi
}

ghinstall() {
  type -p curl >/dev/null || (sudo nala update && sudo nala install curl -y)
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo nala update &&
    sudo nala install gh -y
}

lazygitinstall() {
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
}

if command -v gh >/dev/null 2>&1; then
  alias gh-create='gh pr create -t $(git branch --show-current)'
  alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
  alias gh-complete='gh pr merge --auto --delete-branch --squash'
  alias gh-complete='gh pr merge --auto --delete-branch --squash -t $(git branch --show-current)'
else
  ghinstall
fi

if hash lazygit 2>/dev/null; then
  alias lg='lazygit'
  alias gg='lazygit'
else
  lazygitinstall
fi

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --color=always --long --git --icons=always"
  # alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
  alias ll='ls -l'
  alias la='eza -la'
  alias lt='eza --tree --level=2'
else
  echo "eza is missing"
  echo "Please run:"
  echo ""
  echo "cargo install eza"
  echo ""
fi

if hash nvim 2>/dev/null; then
  alias vim="nvim"
  alias v="nvim"
  alias vi='nvim'
else
  echo "neovim is missing"
fi

# Rebinding -> cat
if [[ $(command -v "bat") ]]; then
  alias cat='bat'
fi

## Zellij
if hash zellij 2>/dev/null; then
  alias zj="zellij a -c 'B+ DevOps'"
  alias zjkl="zellij ka -y"
  alias zjrn="zellij r -- $1"
  alias zjrm="rm -rf ${HOME}/.cache/zellij"
  alias zjls="zellij ls"
  alias zjat="zellij a"
else
  # echo "helix is missing"
fi

alias chmox="chmod +x"

## Clean NVim
alias rmvim="rm -rf ~/.local/share/nvim && rm -rf ~/.cache/nvim && rm -rf ~/.local/state/nvim"
alias bootvim="nvim --headless '+Lazy! sync' +qa"

alias r=reset

# Cargo
# cargo install cargo-cache
# cargo install cargo-update
if command -v cargo >/dev/null 2>&1; then
  alias cr='cargo run --'
  alias ccr='clear && cr'
  alias cargo-install='cargo install --path .'
  alias cargoupgrade='cargo install-update -a'
  # alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')"
  alias cargoclearcache="cargo-cache -r all"
  # alias cargocache="cargo cache -a"
  alias rustupupdate="rustup update && rustup component add rust-analyzer && rustup component list"
fi

# reload zsh config
alias reload!='RELOAD=1 source ~/.config/zsh/.zshrc'

# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

alias cleanapt="df -h && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && df -h"
alias sysupdate="sudo apt update && sudo apt dist-upgrade -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autopurge && sudo apt autoclean && sudo apt clean && flatpak update -y && flatpak uninstall --unused -y"
alias syshealth='sudo nala update && sudo rm /var/lib/apt/lists/lock && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean && flatpak update -y && flatpak uninstall --unused -y && sudo snap refresh'

# Find Files
alias ff="rg --files | sk --preview='bat {} --color=always'"

# Linux version of OSX pbcopy and pbpaste.
# sudo apt install xclip xsel
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'
if command -v xsel >/dev/null 2>&1; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi

if command -v pbpaste >/dev/null 2>&1; then
  alias ccb='pbpaste|pbcopy' # clear clipboard
fi

if command -v tmux >/dev/null 2>&1; then
  alias tmx='tmux new -s $(pwd | sed "s/.*\///g")'
  alias tma='tmux a'
  alias tms='tmux ls'
  alias tmt='tmux attach -t'
  alias tml='tmux list-sessions'
  alias tmc='clear; tmux clear-history; clear'
  alias tmd='tmux detach'
  alias tmk='tmux kill-session'
  alias tmr='tmux kill-session -a' # clear clipboard
  alias tmks='tmux kill-server'
fi

# Colored output
#alias ls='ls -laGH --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

alias gs='git status'
alias ga='git add -A'
alias gc='git commit'
alias gpll='git pull'
alias gpsh='git push'
alias gd='git diff'
alias gl='git log --stat --graph --decorate --oneline'

alias '?'=searchOnDuck
alias '??'=searchOnGoogle

alias xterm="sudo update-alternatives --config x-terminal-emulator"

alias poetryupdate="pipx upgrade poetry"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Nmap
alias nm="nmap -sC -sV -oN nmap"

# HTTP requests with xh!
if command -v xh >/dev/null 2>&1; then
  alias http="xh"
fi

# Docker
if command -v docker >/dev/null 2>&1; then
  alias dco="docker compose"
  alias dps="docker ps"
  alias dpa="docker ps -a"
  alias dl="docker ps -l -q"
  alias dx="docker exec -it"
fi

alias lazysrc="cd ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/"

alias alldate="rustupupdate && cargoupgrade && cargoclearcache && go-global-update && syshealth"
alias updatevim="nvim --headless '+Lazy! sync' +qa"

# Obsidian
alias oo='cd $HOME/wks/2ndBrain/'
alias or='nvim $HOME/wks/2ndBrain/inbox/*.md'
alias ou='cd $HOME/notion-obsidian-sync-zazencodes && node batchUpload.js --lastmod-days-window 5'

# Podman
# if check_command podman; then
#   alias lazypodman='DOCKER_HOST=unix:///run/user/1000/podman/podman.sock lazydocker'
# fi

alias python=python3

# fzf nvim
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# home-manager
alias hm="home-manager"
alias hmd="cd ~/dotfiles/nix-linux/"
alias hmb="home-manager -f home.nix build"
alias hms="home-manager -f home.nix switch"
alias hmsf="home-manager switch --flake ~/dotfiles/nix-linux/home-manager#borba"
alias hmp="home-manager packages"
alias hmu="nix flake update ~/dotfiles/nix-linux && hms"
alias hmg="home-manager generations"
alias nxu="nix-channel --update"
alias ngc="nix-store --gc && nix-collect-garbage -d && home-manager expire-generations '-2 days' && zimfw clean"

# zimfw
alias zfc="zimfw clean"

alias tc="clear; tmux clear-history; clear"
