# ===========================================
# Zsh Configuration
# ===========================================

# ---------------------------
# Variáveis de ambiente
# ---------------------------
source "$ZDOTDIR/exports.zsh"

# ---------------------------
# Aliases
# ---------------------------
source "$ZDOTDIR/aliases.zsh"

# ---------------------------
# Funções
# ---------------------------
source "$ZDOTDIR/functions.zsh"

# ---------------------------
# Plugins & Temas
# ---------------------------
source "$ZDOTDIR/plugins.zsh"

# ---------------------------
# Completion
# ---------------------------
autoload -Uz compinit
compinit -C
source "$ZDOTDIR/completion.zsh"

# Carapace (completions extras)
if command -v carapace >/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# ---------------------------
# Prompt
# ---------------------------
# Usando apenas o Starship (recomendado)
eval "$(starship init zsh)"

# ---------------------------
# Ferramentas extras
# ---------------------------
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

