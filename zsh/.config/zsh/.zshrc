# ===========================================
# ZSH CONFIGURATION (OTIMIZADA E ORGANIZADA)
# ===========================================
# Mantém sua lógica original, apenas reorganizada, otimizada e limpa.
# Nada removido — apenas melhorado.

# -------------------------------------------
# 👉 1) HISTORY CONFIG
# -------------------------------------------
HISTSIZE=20000
SAVEHIST=20000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS

# -------------------------------------------
# 👉 2) BASIC ZSH INIT
# -------------------------------------------
autoload -Uz compinit
compinit -C

# -------------------------------------------
# 👉 3) PLUGINS LOADING (ZINIT)
# -------------------------------------------
{
  source "$ZDOTDIR/plugins.zsh"
} always {
  if alias zi >/dev/null 2>&1; then
    zi_func=$(alias zi | sed "s/^zi='\(.*\)'$/\1/")
    unalias zi
    zi() { eval "$zi_func" "$@" }
  fi
}

[[ -f "$HOME/.zinit/bin/zinit.zsh" ]] && source "$HOME/.zinit/bin/zinit.zsh" || {
  echo "zinit não encontrado"; exit 1;
}
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# -------------------------------------------
# 👉 4) CUSTOM SOURCES
# -------------------------------------------
source "$ZDOTDIR/exports.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

export ZSH_CUSTOM_PLUGINS="${ZDOTDIR}/plugins"

# -------------------------------------------
# 👉 5) AUTOSUGGESTIONS
# -------------------------------------------
if [ -f "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a"
  ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
  ZSH_AUTOSUGGEST_USE_ASYNC=true
  bindkey '^ ' autosuggest-accept
fi

# -------------------------------------------
# 👉 6) CARAPACE
# -------------------------------------------
if command -v carapace >/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# -------------------------------------------
# 👉 7) ATUIN
# -------------------------------------------
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
bindkey '^e' atuin-up-search-viins

# -------------------------------------------
# 👉 8) FZF + FD + PREVIEWS
# -------------------------------------------
# eval "$(fzf --zsh)"
#
# fg="#CBE0F0"
# bg="#011628"
# bg_highlight="#143652"
# purple="#B388FF"
# blue="#06BCE4"
# cpyan="#2CF9ED"
#
# export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
#
# export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
#
# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }
#
# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }
#
# show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
#
# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
#
# _fzf_comprun() {
#   local command=$1
#   shift
#
#   case "$command" in
#     cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
#     export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
#     ssh)          fzf --preview 'dig {}' "$@" ;;
#     *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
#   esac
# }
#
# # -------------------------------------------
# # 👉 9) FZF-TAB (via zinit)
# # -------------------------------------------
# zinit light Aloxaf/fzf-tab


# fzf
# ------------------------------------------------------------------------------
## fzf setup inside this function to append it to zvm_after_init_commands
function fzf_init() {
  if type fzf &>/dev/null; then
    source <(fzf --zsh)

    export FZF_CTRL_R_OPTS="
    --color header:italic
    --height=80%
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'CTRL-Y: Copy command into clipboard, CTRL-/: Toggle line wrapping, CTRL-R: Toggle sorting by relevance'
    "

    export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --height=80%
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
    --header 'CTRL-/: Toggle preview window position'
    "

    export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'
    --height=80%
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
    --header 'CTRL-/: Toggle preview window position'
    "
  else
    echo ERROR: Could not fzf shell integration.
  fi
}

# eza (better `ls`)
# ------------------------------------------------------------------------------
if type eza &>/dev/null; then
  alias l="eza --icons=always"
  alias la="eza -a --icons=always"
  alias lh="eza -ad --icons=always .*"
  alias ll="eza -lg --icons=always"
  alias lla="eza -lag --icons=always"
  alias llh="eza -lagd --icons=always .*"
  alias ls="eza --icons=always"
  alias lt2="eza -lTg --level=2 --icons=always"
  alias lt3="eza -lTg --level=3 --icons=always"
  alias lt4="eza -lTg --level=4 --icons=always"
  alias lt="eza -lTg --icons=always"
  alias lta2="eza -lTag --level=2 --icons=always"
  alias lta3="eza -lTag --level=3 --icons=always"
  alias lta4="eza -lTag --level=4 --icons=always"
  alias lta="eza -lTag --icons=always"
else
  echo ERROR: eza could not be found. Skip setting up eza aliases.
fi

# zoxide (better `cd`)
# ------------------------------------------------------------------------------
# if type zoxide &>/dev/null; then
#   eval "$(zoxide init zsh --cmd cd)"
# else
#   echo ERROR: Could not load zoxide shell integration.
# fi
#
# -------------------------------------------
# 👉 10) UI: STARSHIP + ZOXIDE
# -------------------------------------------
eval "$(starship init $(basename $SHELL))"
eval "$(zoxide init zsh)"

# -------------------------------------------
# 👉 11) NODE/NVM
# -------------------------------------------
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- Integration with tmux & wezterm ---
# Automatic tmux attach on terminal start (unless nested or ssh)
if [[ -z "$TMUX" && -z "$SSH_CONNECTION" ]]; then
  tmux attach || tmux new
fi

# --- Shell Keybindings (ZLE) ---
bindkey -e
bindkey "^[[1;3D" backward-word   # Alt + Left
bindkey "^[[1;3C" forward-word    # Alt + Right
bindkey "^[[1;3A" up-history      # Alt + Up
bindkey "^[[1;3B" down-history    # Alt + Down

# Fuzzy directory jump
# fzf-cd-widget() {
#   local dir=$(fd -t d . ~ | fzf)
#   if [[ -n $dir ]]; then cd "$dir"; zle reset-prompt; fi
# }
# zle -N fzf-cd-widget
# bindkey "^O" fzf-cd-widget
#
# # --- Advanced completions ---
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# zstyle ':completion:*' menu select
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# --- FZF Multi-UI enhancement ---
# export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%"

# --- Custom Starship theme ---
export STARSHIP_CONFIG="$HOME/.config/starship-custom.toml"

microfetch
