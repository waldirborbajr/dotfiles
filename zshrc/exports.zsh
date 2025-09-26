# Variáveis de ambiente
export EDITOR="nvim"
export LANG="en_US.UTF-8"
# export LANG="pt_BR.UTF-8"

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Path helper
path_add() { [[ -d "$1" ]] && PATH="$1:$PATH" }

# PATHs importantes
path_add "$HOME/bin"
path_add "/usr/local/go/bin"
path_add "$HOME/dotfiles/localbin"
path_add "$HOME/go/bin"
path_add "/opt/nvim-linux-x86_64/bin"
path_add "$HOME/.fzf/bin"
path_add "$HOME/ripgrep"
path_add "$HOME/fd"
path_add "$HOME/.local/bin"

export GOPATH="$HOME/go"

# Manpath (caso pacotes instalem manpages extras)
export MANPATH="/usr/local/share/man:$MANPATH"

