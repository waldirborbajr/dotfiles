# Advanced Zsh Completions Configuration
if typeset -f compinit >/dev/null; then
  # Optimize compinit: check cache once daily
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -C
  else
    compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
  fi

  # --- General Completion Settings ---
  # Enable cache for faster completions
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

  # Completion behavior: prioritize extensions, then complete, then approximate
  zstyle ':completion:*' completer _extensions _complete _approximate

  # Case-insensitive and partial matching
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

  # Enable menu selection for interactive completion
  zstyle ':completion:*' menu select

  # --- Formatting and Display ---
  # Minimal formatting for performance
  zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'
  zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'

  # Use LS_COLORS for completion colors
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  # --- Directory and File Handling ---
  # Prioritize local directories and directory stack
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*' special-dirs true
  zstyle ':completion:*' squeeze-slashes true
  zstyle ':completion:*' file-sort modification

  # Disable sorting for specific commands
  zstyle ':completion:*' sort false
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:eza:*' sort false

  # --- Command and Alias Completion ---
  zstyle ':completion:*:-command-:*' group-order aliases builtins functions commands
  zstyle ':completion:*' complete-aliases true
  zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

  # --- fzf-tab Integration ---
  zstyle ':fzf-tab:*' fzf-command fzf
  zstyle ':fzf-tab:*' fzf-flags '--color=light --height=30% --layout=reverse --border'
  zstyle ':fzf-tab:*' fzf-pad 2
  zstyle ':fzf-tab:*' fzf-min-height 15
  zstyle ':fzf-tab:*' continuous-trigger false

  # Lightweight previews
  zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && ls --color=always $realpath || head -50 $realpath 2>/dev/null'
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
  zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers'
  zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:2:wrap'

  # Git-specific previews
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word 2>/dev/null'
  zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git show --color=always $word | head -50'
fi
