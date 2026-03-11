# Rust setup
. "$HOME/.cargo/env"
[[ -f $HOME/.zprofile ]] && source $HOME/.zprofile

## Completion
autoload -U compinit; compinit
zstyle ':completion:*' menu select
# This handles completion search when I already typed the start of the command
# https://unix.stackexchange.com/a/672892
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/fzf/shell/key-bindings.zsh 

## VI mode
bindkey -v
# makes the change quicker https://thevaluable.dev/zsh-install-configure-mouseless/
export KEYTIMEOUT=1

## Aliases
source $ZDOTDIR/aliases.zsh

## Plugins
source $ZDOTDIR/plugins.zsh

# -------------------------------------------
# 👉 CUSTOM SOURCES
# -------------------------------------------
source "$ZDOTDIR/functions.zsh"
# source "$ZDOTDIR/aliases.zsh"
# source "$ZDOTDIR/hack.zsh"

## GOLang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

## Prompt
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
# eval "$(starship init zsh)"

# starship
(( $+commands[starship] )) && eval "$(starship init zsh)"

# Zellij pane renaming hooks - AFTER starship, BEFORE zellij auto-start
# so they don't interfere with starship's own prompt hooks
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

# zellij
(( $+commands[zellij] )) && eval "$(zellij setup --generate-auto-start zsh)"

