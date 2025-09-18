# Completions avançadas
if typeset -f compinit >/dev/null; then
  # Case-insensitive tab completion
  zstyle ':completion:*' completer _complete _ignored _approximate
  zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
  zstyle ':completion:*' menu select
  zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
  zstyle ':completion:*' verbose true

  # Enable cache for completions
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
fi
