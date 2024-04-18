#!/bin/bash

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"

bindkey -r '^T'
bindkey '^Y' fzf-file-widget

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/borba/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/borba/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/borba/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/borba/.fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_OPTS="
  --bind ctrl-j:down,ctrl-k:up
  --bind='?:toggle-preview'
  --exact
  --reverse
  --cycle
  --height=50%
  --info=inline
  --prompt=❯\
  --pointer=→
  --color=dark
  --color=fg:-1,bg:-1,hl:#9ece6a,fg+:#a9b1d6,bg+:#1D202F,hl+:#9ece6a
  --color=info:#9ece6a,prompt:#7aa2f7,pointer:#9ece6a,marker:#e5c07b,spinner:#61afef,header:#7aa2f7
  --preview '([[ -d {} ]] && tree -C {}) || ([[ -f {} ]] && bat --style=full --color=always {}) || echo {}'"
