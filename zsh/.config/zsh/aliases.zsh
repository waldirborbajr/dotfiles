# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Modern ls replacement
alias ll="eza -lg --icons --group-directories-first"
alias la="eza -lag --icons --group-directories-first"

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'
alias ghc='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# Aliases: git
alias git-notes='git -C ~/notes'
alias git-when='git -C ~/.when'
alias git-ledger='git -C ~/.ledger'

alias sync-commit-notes='git-notes add --all; git-notes commit --message sync; git-notes pull; git-notes push'

alias cj-pull='pass git pull; git-notes pull; git-when pull; git-ledger pull'
alias cj-status='pass git status; git-notes status; git-when status; git-ledger status'

# System
alias dc='docker compose'
alias reboot="systemctl reboot"
alias rmvim="rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim"
alias xterm="sudo update-alternatives --config x-terminal-emulator"

alias nv="nvim"
alias yz="yazi"
alias lg="lazygit"

gcm() { git commit --message "$*" }

# Aliases: docker
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dl='docker logs --tail=100'
alias dc='docker compose'

# Aliases: tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

# Aliases: rg
alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim --colors=line:fg:black --colors=line:style:bold --colors=path:fg:magenta --colors=match:style:nobold"

# System
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias c='clear'
alias e='exit'

# Function to commit with ticket ID from current branch, with optional push
quick_commit() {
  local branch_name ticket_id commit_message push_flag
  branch_name=$(git branch --show-current)
  ticket_id=$(echo "$branch_name" | awk -F '-' '{print toupper($1"-"$2)}')
  commit_message="$ticket_id: $*"
  push_flag=$1

  if [[ "$push_flag" == "push" ]]; then
    # Remove 'push' from the commit message
    commit_message="$ticket_id: ${*:2}" # take all positional parameters starting from the second one
    git commit --no-verify -m "$commit_message" && git push
  else
    git commit --no-verify -m "$commit_message"
  fi
}

alias gqc='quick_commit'
alias gqcp='quick_commit push'
