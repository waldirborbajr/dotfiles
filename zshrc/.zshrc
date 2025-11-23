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
# Atuin Configs
# ---------------------------
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
# bindkey '^r' _atuin_search_widget
bindkey '^e' atuin-up-search-viins
#User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- FZF () -----

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# ---------------------------
# Prompt & Tools
# ---------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


