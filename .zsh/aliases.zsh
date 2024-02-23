#!/usr/bin/env zsh

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
  alias ls='eza'
  alias ll='ls -l'
  alias la='eza -la'
  alias lt='exa --tree --level=2'
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
  echo "helix is missing"
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

if command -v fzf >/dev/null 2>&1; then
  alias pf="fzf ${FZF_CTRL_T_OPTS}"
else
  echo "fzf is missing"
  echo "Please install fzf"
  echo ""
  echo "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
  echo "~/.fzf/install"
fi

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

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
  alias tmr='tmux kill-session -a' # clear clipboard
  alias tma='tmux attach'
  alias tms='tmux ls'
  alias tmt='tmux attach -t'
  alias tmx='tmux new-session -s TmX'
  alias tml='tmux list-sessions'
  alias tmc='clear; tmux clear-history; clear'
  alias tmd='tmux detach'
  alias tmk='tmux kill-session'
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

lias poetryupdate="pipx upgrade poetry"
