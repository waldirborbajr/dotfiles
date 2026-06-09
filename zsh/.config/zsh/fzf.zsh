# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# =============================================
# FORÇAR CARREGAMENTO DO CTRL+R DO FZF
# =============================================

# Tenta carregar key bindings do fzf de todas as formas possíveis
if ! zle -l | grep -q fzf-history-widget; then
  for kb in \
    /usr/share/fzf/key-bindings.zsh \
    /usr/share/doc/fzf/examples/key-bindings.zsh \
    /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
    /usr/local/opt/fzf/shell/key-bindings.zsh; do

    if [[ -f "$kb" ]]; then
      source "$kb"
      break
    fi
  done
fi

# Fallback manual se ainda não carregou
if ! zle -l | grep -q fzf-history-widget; then
  # Define o widget manualmente (versão simplificada)
  fzf-history-widget() {
    local selected
    selected=$(fc -l 1 | fzf --height 60% --reverse --tac --query="$LBUFFER")
    if [[ -n "$selected" ]]; then
      zle -U "$(echo "$selected" | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')"
    fi
  }
  zle -N fzf-history-widget
fi

_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
