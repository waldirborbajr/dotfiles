# -------------------------------------------
# ⚙️ BASE
# -------------------------------------------

# Rust
. "$HOME/.cargo/env"
[[ -f $HOME/.zprofile ]] && source $HOME/.zprofile

# Go (prepend no PATH)
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"

# -------------------------------------------
# ⚡ COMPLETION (com cache)
# -------------------------------------------

autoload -U compinit
compinit -d ~/.zcompdump

zstyle ':completion:*' menu select

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# -------------------------------------------
# 🔍 FZF (clean)
# -------------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Melhor UX
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
  --height 60%
  --layout=reverse
  --border
  --preview "bat --style=numbers --color=always {} | head -500"
'

# -------------------------------------------
# 🧠 ATUIN (depois dos binds)
# -------------------------------------------

export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

bindkey '^R' atuin-search

# -------------------------------------------
# 🧠 VI MODE
# -------------------------------------------

bindkey -v
export KEYTIMEOUT=1

# -------------------------------------------
# 🔌 PLUGINS / CUSTOM
# -------------------------------------------

source $ZDOTDIR/plugins.zsh

source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"
# source "$ZDOTDIR/hack.zsh"

# -------------------------------------------
# ⭐ PROMPT (Starship)
# -------------------------------------------

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# -------------------------------------------
# 🧩 ZELLIJ
# -------------------------------------------

if [[ -n "$ZELLIJ" ]]; then
  preexec() {
      zellij action rename-pane "⚙ ${1%% *}"
  }

  precmd() {
      local name
      name=$(git rev-parse --show-toplevel 2>/dev/null)

      if [[ -n "$name" ]]; then
          name=$(basename "$name")
      else
          name=$(basename "$PWD")
      fi

      zellij action rename-pane "$name"
  }
fi

(( $+commands[zellij] )) && eval "$(zellij setup --generate-auto-start zsh)"
