#!/usr/bin/env zsh

hinstall() {
  if hash pacman 2>/dev/null; then
    echo "Installing $1"
    # sudo pacman -S $1
    yay -S $1
  elif hash pkg 2>/dev/null; then
    case $1 in
      xclip | fping)
        return
        ;;
    esac
    echo "Installing $1"
    pkg install $1
  fi
  zsh
}

if hash gh 2>/dev/null; then
  alias gh-create='gh pr create -t $(git branch --show-current)'
  alias gh-create-web='gh pr create -w -t $(git branch --show-current)'
  # alias gh-complete='gh pr merge --auto --delete-branch --squash'
  # alias gh-complete='gh pr merge --auto --delete-branch --squash -t $(git branch --show-current)'

else
  echo "gh is missing"
  # install github-cli
fi

if hash lazygit 2>/dev/null; then
  alias lg='lazygit'
  alias gg='lazygit'
else
  echo "lazygit is missing"
  # install lazygit
fi

if command -v eza &>/dev/null; then
  alias l='eza'
  alias ls='eza --group-directories-first --icons --git'
  alias ll='ls -lah --git'
  alias la='eza -a'
  alias tree='ll --tree --level=2'
else
  echo "eza is not installed."
  # install eza
fi

if hash nvim 2>/dev/null; then
  alias vim="nvim"
  alias v="nvim"
  alias vi='nvim'
else
  echo "neovim is missing"
  # install neovim
fi

if hash hx 2>/dev/null; then
  alias h='hx'
else
  echo "helix is missing"
fi

# Rebinding -> ls
# if [[ $(command -v "exa") ]]; then
#   # alias ls="exa --icons"
#   alias ls='eza -a --icons'
#   alias ll="exa -lha --icons"
#   alias l="exa -lh --icons"
#   # alias la="exa -lah"
#   alias tree="exa --tree --level 2"
# fi

# Rebinding -> cat
if [[ $(command -v "bat") ]]; then
  alias cat='bat'
fi

## Zellij
if hash zellij 2>/dev/null; then
  # alias zj="zellij a -c 'B+ DevOps'"
  alias zj="zellij"
  alias zjrs="zellij --layout $HOME/.config/zellij/zelliRUST.kdl a -c 'B+ DevRust'"
  alias zjgo="zellij --layout $HOME/.config/zellij/zelliGO.kdl a -c 'B+ DeviGO'"
  alias zjkl="zellij ka -y"
  alias zjrn="zellij r -- $1"
  alias zjrm="rm -rf /home/borba/.cache/zellij"
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
alias cr='cargo run --'
alias ccr='clear && cr'
alias cargo-install='cargo install --path .'
alias cargo-upgrade='cargo install-update -a'
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') --force"
alias cargoclearcache="cargo-cache -r all"
alias cargocache="cargo cache -a"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

alias cleanapt="df -h && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && df -h"


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
