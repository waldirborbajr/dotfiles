#!/usr/bin/env zsh

ghinstall() {
  type -p curl >/dev/null || (sudo nala update && sudo nala install curl -y)
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo nala update \
  && sudo nala install gh -y
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

if [[ -e $HOME/.cargo/bin/exa ]]; then
  alias l='eza'
  alias ls='eza --group-directories-first --icons --git'
  alias ll='ls -lah --git'
  alias la='eza -a'
  alias tree='ll --tree --level=2'
else
  echo "eza is missing"
  echo "Please run:"
  echo ""
  echo "cargo install exa"
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
alias resetvim="nvim --headless '+Lazy! sync' +qa"

alias r=reset

# Cargo
# cargo install cargo-cache
# cargo install cargo-update
if command -v cargo >/dev/null 2>&1; then
  alias cr='cargo run --'
  alias ccr='clear && cr'
  alias cargo-install='cargo install --path .'
  alias cargo-upgrade='cargo install-update -a'
  alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') --force"
  alias cargoclearcache="cargo-cache -r all"
  alias cargocache="cargo cache -a"
  alias rustupfull="rustup update && rustup component add rust-analyzer && rustup component list"
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
alias syshealth='sudo nala update && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean && flatpak update -y && flatpak uninstall --unused -y'

# Find Files
alias ff="rg --files | sk --preview='bat {} --color=always'"

# Linux version of OSX pbcopy and pbpaste.
# sudo apt install xclip xsel
# alias pbcopy='xclip -selection clipboard'
# alias pbpaste='xclip -selection clipboard -o'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

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
