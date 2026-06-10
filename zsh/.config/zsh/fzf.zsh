# =========================================================
# fzf
# =========================================================

# --strip-cwd-prefix adicionado no fd 8.3.0; detecta suporte em runtime
# Sempre passa '.' explicitamente para evitar erro em versões antigas do fd
_fd_base='fd --type f --hidden .'
if fd --strip-cwd-prefix . /dev/null &>/dev/null 2>&1; then
  _fd_base='fd --type f --hidden --strip-cwd-prefix .'
fi

export FZF_DEFAULT_COMMAND="$_fd_base"
export FZF_CTRL_T_COMMAND="$_fd_base"
unset _fd_base

# UI
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

# Registra fzf-history-widget e demais widgets.
# DEVE rodar antes de plugins.zsh carregar o zsh-vi-mode,
# para que o widget exista quando zvm_after_init() fizer bindkey.
if command -v fzf &>/dev/null; then
  if fzf --zsh &>/dev/null 2>&1; then
    eval "$(fzf --zsh)"
  else
    for _fzf_kb in \
      /usr/share/fzf/key-bindings.zsh \
      /usr/share/doc/fzf/examples/key-bindings.zsh \
      /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
      /usr/local/opt/fzf/shell/key-bindings.zsh; do
      [[ -f "$_fzf_kb" ]] && { source "$_fzf_kb"; break; }
    done
    for _fzf_comp in \
      /usr/share/fzf/completion.zsh \
      /usr/share/doc/fzf/examples/completion.zsh \
      /opt/homebrew/opt/fzf/shell/completion.zsh \
      /usr/local/opt/fzf/shell/completion.zsh; do
      [[ -f "$_fzf_comp" ]] && { source "$_fzf_comp"; break; }
    done
    unset _fzf_kb _fzf_comp
  fi
fi

# Ctrl+F: file picker excluindo hidden files
_fzf_file_no_hidden() {
  local result
  result=$(fd --type f . | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
