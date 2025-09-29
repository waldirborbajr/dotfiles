#===========================================
#Zsh Configuration
#===========================================

# ---------------------------
# History settings
# ---------------------------

# Tamanho do histórico
HISTSIZE=20000        # comandos mantidos em memória
SAVEHIST=20000        # comandos salvos no arquivo

# Arquivo onde o histórico será salvo
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

# Opções de histórico
setopt APPEND_HISTORY         # adiciona em vez de sobrescrever
setopt SHARE_HISTORY          # compartilha histórico entre sessões
setopt HIST_IGNORE_ALL_DUPS   # remove duplicados
setopt HIST_REDUCE_BLANKS     # remove espaços extras
setopt HIST_IGNORE_SPACE      # não salva comandos que começam com espaço
setopt EXTENDED_HISTORY       # salva timestamp junto com os comandos
setopt HIST_SAVE_NO_DUPS      # não salva duplicados no arquivo
setopt HIST_VERIFY            # confirma antes de executar comando do histórico
setopt HIST_FIND_NO_DUPS      # evita mostrar duplicados ao pesquisar

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

export ZSH_CUSTOM_PLUGINS="${ZDOTDIR}/plugins"

# Source zsh-autosuggestions
if [ -f "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"
    
    # Configurações do zsh-autosuggestions
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a"
    ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
    # ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    bindkey '^ ' autosuggest-accept
fi

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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
