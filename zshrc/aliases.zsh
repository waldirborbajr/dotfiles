# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Modern ls replacement
alias ll="eza -lg --icons --group-directories-first"
alias la="eza -lag --icons --group-directories-first"

# Git shortcuts
alias g="git"
alias gs="git status -s"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --all"
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# System
alias dc='docker compose'
alias reboot="systemctl reboot"
alias rmvim="rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim"
alias xterm="sudo update-alternatives --config x-terminal-emulator"

alias v="nvim"
alias y="yazi"

# # Aliases úteis
# # alias ll='ls -la --color=auto'
# alias ll="eza -lg --icons --group-directories-first"
# alias la="eza -lag --icons --group-directories-first"
# alias gs='git status'
# alias dc='docker compose'
# alias rmvim="rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim"
#
# alias gcmsg='git commit -m'
# alias gaa='git add --all'
# alias gp='git push'
# alias gl='git pull'
# # git aliases
# alias gt="git"
# alias ga="git add ."
# alias gs="git status -s"
# alias gc='git commit -m'
# alias glog='git log --oneline --graph --all'
# alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'
#
# alias reboot="systemctl reboot"
# alias xterm="sudo update-alternatives --config x-terminal-emulator"
#
# alias ".."="cd .."
# alias "..."="cd ../.."
# alias "...."="cd ../../.."
# alias "....."="cd ../../../.."
#
# alias rustupdate="rustup self update"
#
