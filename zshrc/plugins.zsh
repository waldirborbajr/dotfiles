# Exemplo com zinit (plugin manager rápido)
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    mkdir -p "$HOME/.zinit" && git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi
source "$HOME/.zinit/bin/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
