# Powerful but minimal zsh configuration
# Author: Radley E. Sidwell-Lewis
# GitHub: https://www.github.com/radleylewis/zsh
#
# Uses:
#   Plugins:      fast-syntax-highlighting, zsh-autosuggestions,
#                 zsh-history-substring-search, zsh-vi-mode
#   Prompt:       starship
#   Navigation:   zoxide, fzf, fd
#   CLI tools:    eza, bat, nvim, ripgrep
#   Node:         nvm (lazy loaded)

# =========================================================
# History
# =========================================================

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# =========================================================
# Smart directory navigation
# =========================================================

eval "$(zoxide init zsh)"

# =========================================================
# Completion
# =========================================================

autoload -Uz compinit

# Recompila o zcompdump só se tiver mais de 24h — acelera startup
if [[ -n "$XDG_CACHE_HOME/zsh/zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
else
  compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump"
fi

autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _approximate

# =========================================================
# Modular Config Files
# =========================================================

# fzf: env vars + registra fzf-history-widget e demais widgets
source "$ZDOTDIR/fzf.zsh"

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Functions
source "$ZDOTDIR/functions.zsh"

# Plugins — deve vir ANTES de bindings.zsh
# zsh-vi-mode reseta todos os bindkeys ao inicializar e depois chama
# zvm_after_init(); esse hook só funciona se o plugin já estiver carregado
# quando bindings.zsh for sourced.
source "$ZDOTDIR/plugins.zsh"

# Keybindings — usa zvm_after_init(), que já existe após plugins.zsh
source "$ZDOTDIR/bindings.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"

# =========================================================
# Node / NVM — lazy load
# Adia o source do nvm.sh para o primeiro uso real,
# economizando ~200-500ms no startup do shell.
# =========================================================

_nvm_lazy_load() {
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ]         && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
nvm()  { _nvm_lazy_load; nvm  "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm()  { _nvm_lazy_load; npm  "$@"; }
npx()  { _nvm_lazy_load; npx  "$@"; }
