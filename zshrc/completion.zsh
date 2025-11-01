# Advanced Zsh Completions Configuration
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -C
else
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
fi

# --- Configurações Básicas de Completion ---
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' completer _extensions _complete _approximate

# Case-insensitive matching
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

# --- CONFIGURAÇÃO SIMPLES PARA TABULAÇÃO CÍCLICA ---
# Menu de seleção automático
zstyle ':completion:*' menu select=1

# Cores e formatação
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Comportamento para diretórios
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Desativa ordenação para alguns comandos
zstyle ':completion:*' sort false
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:eza:*' sort false

# Aliases e comandos
zstyle ':completion:*:-command-:*' group-order aliases builtins functions commands
zstyle ':completion:*' complete-aliases true

# --- CONFIGURAÇÃO DE TECLAS SIMPLIFICADA ---
# Remove binds problemáticos e usa configuração básica

# Para forçar o menu sempre (fallback)
zstyle ':completion:*:default' menu select=1
