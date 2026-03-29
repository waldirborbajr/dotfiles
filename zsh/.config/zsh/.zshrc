# -------------------------------------------
# ⚙️ BASE
# -------------------------------------------

# Rust
. "$HOME/.cargo/env"
[[ -f $HOME/.zprofile ]] && source $HOME/.zprofile

# Go
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"

# -------------------------------------------
# 🔌 PLUGINS (ANTES DO COMPINIT)
# -------------------------------------------

source $ZDOTDIR/plugins.zsh

# -------------------------------------------
# ⚡ COMPLETION (rápido)
# -------------------------------------------

autoload -U compinit
compinit -d ~/.zcompdump

zstyle ':completion:*' menu select

# Navegação no histórico com setas (inteligente)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# -------------------------------------------
# 🔍 FZF (tunado)
# -------------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
  --height 60%
  --layout=reverse
  --border
  --info=inline
  --preview "bat --style=numbers --color=always {} | head -500"
  --bind "ctrl-/:toggle-preview"
'

# atalhos extras
bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-widget

# -------------------------------------------
# 🧠 ATUIN (histórico GOD MODE)
# -------------------------------------------

export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

# Ctrl+R inteligente
bindkey '^R' atuin-search

# Sync + config avançada
export ATUIN_CONFIG_DIR="$HOME/.config/atuin"

# -------------------------------------------
# 🧠 VI MODE
# -------------------------------------------

bindkey -v
export KEYTIMEOUT=1

# ESC rápido
bindkey -M viins 'jj' vi-cmd-mode

# -------------------------------------------
# 🔌 CUSTOM
# -------------------------------------------

source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

# -------------------------------------------
# ⭐ PROMPT
# -------------------------------------------

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# -------------------------------------------
# 🧩 ZELLIJ
# -------------------------------------------

# if [[ -n "$ZELLIJ" ]]; then
#   preexec() {
#       zellij action rename-pane "⚙ ${1%% *}"
#   }
#
#   precmd() {
#       local name
#       name=$(git rev-parse --show-toplevel 2>/dev/null)
#
#       if [[ -n "$name" ]]; then
#           name=$(basename "$name")
#       else
#           name=$(basename "$PWD")
#       fi
#
#       zellij action rename-pane "$name"
#   }
# fi
#
# (( $+commands[zellij] )) && eval "$(zellij setup --generate-auto-start zsh)"
