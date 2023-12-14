alias '?'=searchOnDuck
alias '??'=searchOnGoogle

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
aias h='hx'

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
alias cargofullcache="cargo-cache -r all"
alias cargocache="cargo cache -a"

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

alias cleanapt="df -h && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && df -h"

# Rebinding -> ls
if [[ $(command -v "exa") ]]; then
  # alias ls="exa --icons"
  alias ls='eza -a --icons'
  alias ll="exa -lha --icons"
  alias l="exa -lh --icons"
  # alias la="exa -lah"
  alias tree="exa --tree --level 2"
fi

# Rebinding -> cat
if [[ $(command -v "bat") ]]; then
  alias cat='bat'
fi

# Find Files
alias ff="rg --files | sk --preview='bat {} --color=always'"

## Zellij
# alias zj="zellij a -c 'B+ DevOps'"
alias zj="zellij"
alias zjrs="zellij --layout $HOME/.config/zellij/zelliRUST.kdl a -c 'B+ DevRust'"
alias zjgo="zellij --layout $HOME/.config/zellij/zelliGO.kdl a -c 'B+ DeviGO'"
alias zjkl="zellij ka -y"
alias zjrn="zellij r -- $1"
alias zjrm="rm -rf /home/borba/.cache/zellij"
alias zjls="zellij ls"
alias zjat="zellij a"

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
