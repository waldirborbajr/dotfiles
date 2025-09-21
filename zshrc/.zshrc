# ===========================================
# Zsh Configuration
# ===========================================

# ---------------------------
# Basic zsh setup
# ---------------------------
autoload -Uz compinit
compinit -C

# ---------------------------
# Temporarily disable alias expansion during plugin loading
# ---------------------------
{
  # Load plugins (Zinit)
  source "$ZDOTDIR/plugins.zsh"
} always {
  # Convert zi alias to function to prevent conflicts
  if alias zi >/dev/null 2>&1; then
    zi_func=$(alias zi | sed "s/^zi='\(.*\)'$/\1/")
    unalias zi
    zi() { eval "$zi_func" "$@" }
  fi
}

# ---------------------------
# Source other files
# ---------------------------
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

# ---------------------------
# Carapace
# ---------------------------
if command -v carapace >/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# ---------------------------
# Prompt & Tools
# ---------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configuração do zinit
[[ -f "$HOME/.zinit/bin/zinit.zsh" ]] && source "$HOME/.zinit/bin/zinit.zsh" || { echo "zinit não encontrado"; exit 1; }
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Configuração do fzf-tab via zinit
zinit light Aloxaf/fzf-tab

eval "$(starship init $(basename $SHELL))"

source <(carapace _carapace $(basename $SHELL))
