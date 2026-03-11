# Own
alias vim="nvim"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias ses="sh $XDG_CONFIG_HOME/tmux/tmux-sessionizer.sh"
alias reload="source $ZDOTDIR/.zshrc"
alias edit="nvim $ZDOTDIR/.zshrc"

# Colors
alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c=auto'

# Files
alias ..='cd ..'
alias l='ls'
alias ll='ls -l'
alias la='ls -lA'

# Git
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias g='git'
alias gst='git status'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gc='git commit --vebose'
alias ga='git add'
alias gsw='git switch'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"

# Dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias d='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

#######################################
# Navigation
#######################################
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

#######################################
# Modern ls replacement
#######################################
alias ll="eza -lg --icons --group-directories-first"
alias la="eza -lag --icons --group-directories-first"

#######################################
# Git aliases
#######################################
alias ga='git add'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch --all'
alias gc='git commit'
alias gca='git commit --amend --no-edit'
alias gce='git commit --amend'
alias gco='git checkout'
alias gn='git checkout -b'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='git diff --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white)%an %ar%C(auto) %D%n%s%n"'
alias gm='git merge'
alias gp='git push'
alias gu='git pull'
alias gr='git reset'
alias gs='git status --short'

alias ghc='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

#######################################
# Git worktrees / repos
#######################################
alias git-notes='git -C ~/notes'
alias git-when='git -C ~/.when'
alias git-ledger='git -C ~/.ledger'

alias sync-commit-notes='git-notes add --all && git-notes commit -m sync && git-notes pull && git-notes push'

alias cj-pull='pass git pull; git-notes pull; git-when pull; git-ledger pull'
alias cj-status='pass git status; git-notes status; git-when status; git-ledger status'

#######################################
# Docker
#######################################
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dl='docker logs --tail=100'

#######################################
# Tmux
#######################################
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

#######################################
# Ripgrep
#######################################
alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim \
--colors=line:fg:black --colors=line:style:bold \
--colors=path:fg:magenta --colors=match:style=nobold"

#######################################
# System
#######################################
alias reboot='systemctl reboot'
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'

alias syslist='systemctl list-units --type=service --state=running'

alias rmvim='rm -rf ~/.local/state/nvim ~/.local/share/nvim ~/.cache/nvim'
alias xterm='sudo update-alternatives --config x-terminal-emulator'

#######################################
# Utils
#######################################
alias nv='nvim'
alias vim='nvim'
alias lg='lazygit'
alias yz='yazi'

alias c='clear'
alias e='exit'

alias ip='ip -c'
alias free='free -h'
alias df='df -h'
alias tree='tree -a'
alias diff='diff --color'
alias ls='ls -h --color=auto'

alias chmodx='chmod +x'

#######################################
# Paths
#######################################
alias dot='cd ~/dotfiles'
alias prj='cd ~/prj'

#######################################
# Quick commit helper
#######################################
quick_commit() {
  local branch ticket msg
  branch=$(git branch --show-current)
  ticket=$(echo "$branch" | awk -F- '{print toupper($1"-"$2)}')

  if [[ "$1" == "push" ]]; then
    msg="$ticket: ${*:2}"
    git commit --no-verify -m "$msg" && git push
  else
    msg="$ticket: $*"
    git commit --no-verify -m "$msg"
  fi
}

alias gqc='quick_commit'
alias gqcp='quick_commit push'

#######################################
# Misc / shortcuts
#######################################
alias todo='nvim ~/.todo'
alias '?'='gpt'
alias '??'='duck'
alias '???'='google'
