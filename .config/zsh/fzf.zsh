#!/bin/bash

if ! command -v fzf &>/dev/null; then
  exit
fi

# cargo install fd-find
# export FZF_TMUX=1
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd --type d . --hidden"
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --height 50 --min-height 100"
# export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

export FZF_DEFAULT_COMMAND='fd --type f -H --exclude ".git" --exclude "node_modules"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

bindkey -r '^T'
bindkey '^Y' fzf-file-widget

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2>/dev/null

source "/usr/local/opt/fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS='
    --bind ctrl-j:down,ctrl-k:up
    --exact
    --reverse
    --cycle
    --height=20%
    --info=inline
    --prompt=❯\
    --pointer=→
    --color=dark
    --color=fg:-1,bg:-1,hl:#9ece6a,fg+:#a9b1d6,bg+:#1D202F,hl+:#9ece6a
    --color=info:#9ece6a,prompt:#7aa2f7,pointer:#9ece6a,marker:#e5c07b,spinner:#61afef,header:#7aa2f7'

# this is what matters
# FZF_COMMON_OPTIONS="
#   --bind='?:toggle-preview'
#   --bind='ctrl-u:preview-page-up'
#   --bind='ctrl-d:preview-page-down'
#   --preview-window 'right:60%:hidden:wrap'
#   --height 100
#   --min-height 50
#   --preview '([[ -d {} ]] && tree -C {}) || ([[ -f {} ]] && bat --style=full --color=always {}) || echo {}'"
