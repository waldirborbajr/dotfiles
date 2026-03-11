#######################################
# Editor
#######################################
alias vim="nvim"
alias nv="nvim"
alias edit="nvim $ZDOTDIR/.zshrc"

#######################################
# Shell / Config
#######################################
alias reload="source $ZDOTDIR/.zshrc"

#######################################
# Navigation
#######################################
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

#######################################
# Modern ls (eza)
#######################################
alias ls="eza --icons --group-directories-first"
alias ll="eza -lg --icons --group-directories-first"
alias la="eza -lag --icons --group-directories-first"

#######################################
# Colors / CLI improvements
#######################################
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ip="ip -c"

#######################################
# Filesystem utils
#######################################
alias tree="tree -a"
alias free="free -h"
alias df="df -h"
alias chmodx="chmod +x"

#######################################
# Git
#######################################
alias g="git"
alias ga="git add"
alias gap="git add --patch"

alias gb="git branch"
alias gba="git branch --all"

alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gce="git commit --amend"

alias gco="git checkout"
alias gn="git checkout -b"

alias gcl="git clone --recursive"

alias gd="git diff"
alias gds="git diff --staged"

alias gi="git init"

alias gl="git log --graph --all --pretty=format:'%C(magenta)%h %C(white)%an %ar%C(auto) %D%n%s%n'"

alias gm="git merge"
alias gp="git push"
alias gu="git pull"

alias gr="git reset"
alias gs="git status --short"

alias ghc="gh repo create --private --source=. --remote=origin && git push -u --all && gh browse"

#######################################
# Dotfiles
#######################################
alias dotfiles="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias d="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias dot="cd ~/dotfiles"

#######################################
# Git repos shortcuts
#######################################
alias git-notes="git -C ~/notes"
alias git-when="git -C ~/.when"
alias git-ledger="git -C ~/.ledger"

alias sync-commit-notes="git-notes add --all && git-notes commit -m sync && git-notes pull && git-notes push"

alias cj-pull="pass git pull; git-notes pull; git-when pull; git-ledger pull"
alias cj-status="pass git status; git-notes status; git-when status; git-ledger status"

#######################################
# Docker
#######################################
alias dc="docker compose"
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dl="docker logs --tail=100"

#######################################
# Tmux
#######################################
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias ta="tmux attach"
alias tl="tmux list-sessions"
alias tn="tmux new-session -s"
alias ses="sh $XDG_CONFIG_HOME/tmux/tmux-sessionizer.sh"

#######################################
# Ripgrep
#######################################
alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim \
--colors=line:fg:black --colors=line:style:bold \
--colors=path:fg:magenta --colors=match:style=nobold"

#######################################
# System
#######################################
alias reboot="systemctl reboot"
alias shutdown="sudo shutdown now"
alias restart="sudo reboot"
alias suspend="sudo pm-suspend"

alias syslist="systemctl list-units --type=service --state=running"

alias rmvim="rm -rf ~/.local/state/nvim ~/.local/share/nvim ~/.cache/nvim"

#######################################
# Utils
#######################################
alias lg="lazygit"
alias yz="yazi"

alias c="clear"
alias e="exit"

#######################################
# Paths
#######################################
alias prj="cd ~/prj"

#######################################
# Misc
#######################################
alias todo="nvim ~/.todo"
alias '?'="gpt"
alias '??'="duck"
alias '???'="google"
