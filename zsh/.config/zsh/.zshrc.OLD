# -------------------------------------------
# ⚙️ BASE
# -------------------------------------------

# Rust
. "$HOME/.cargo/env"
[[ -f $HOME/.zprofile ]] && source $HOME/.zprofile

# Go
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go/bin"

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

# bindkey "^[[A" up-line-or-beginning-search
# bindkey "^[[B" down-line-or-beginning-search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

bindkey '^[[3~' delete-char

# --- fzf support --------------------------------------------------------------

configureFZF() {
    export FZF_DEFAULT_OPTS='--height 75% --layout=reverse --border --no-hscroll --info inline-right'

    # prefer fd
    if command -v fd &> /dev/null ; then
        export FZF_DEFAULT_COMMAND="fd --ignore-vcs -tl -tf"
        export FZF_ALT_C_COMMAND="fd --ignore-vcs -tl -td"
    else
        # use ripgrep
        if command -v rg &> /dev/null ; then
            export FZF_DEFAULT_COMMAND='rg --follow --ignore-vcs --files'
        fi
    fi

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
}

if command -v fzf &> /dev/null ; then
    # Argument '--zsh' available starting v0.48
    eval "$(fzf --zsh 2>/dev/null)"

    configureFZF

elif [ -f ~/.fzf.zsh ] ; then
    # Used when installing fzf from a custom source or location
    source ~/.fzf.zsh

    configureFZF
fi

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#
# export FZF_DEFAULT_OPTS='
#   --height 60%
#   --layout=reverse
#   --border
#   --info=inline
#   --preview "bat --style=numbers --color=always {} | head -500"
#   --bind "ctrl-/:toggle-preview"
# '
#
# # atalhos extras
# bindkey '^P' fzf-file-widget
# bindkey '^O' fzf-cd-widget

# -------------------------------------------
# 🧠 ATUIN (histórico GOD MODE)
# -------------------------------------------

export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"

# Ctrl+R inteligente
bindkey '^R' atuin-search

# Sync + config avançada
export ATUIN_CONFIG_DIR="$HOME/.config/atuin"

# --- better cd command --------------------------------------------------------

if command -v zoxide &> /dev/null ; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# --- convienient process searching and killing --------------------------------

alias psg='ps aux | grep -v grep | grep'

psf() {
    ps -Ar -o user,pid,ppid,start,time,command | fzf --query=$@ \
        --header 'CTRL-R -> refresh, CTRL-Y -> kill' \
        --header-lines=1 --height=75% --layout=reverse \
        --info inline-right --border --nth=1,2,6 \
        --no-hscroll \
        --preview 'echo {2} {6..}' --preview-window up:2:wrap:follow \
        --bind 'ctrl-r:reload(ps -Ar -o user,pid,ppid,start,time,command)' \
        --bind 'ctrl-y:reload(kill {2} || ps -Ar -o user,pid,ppid,start,time,command)'
}

# --- extract files from any archive -------------------------------------------
# Usage: ex <archive_name>

ex()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) 7zz x $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7zz x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


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
