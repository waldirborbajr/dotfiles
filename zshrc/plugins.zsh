# ===========================================
# Plugins com Zinit
# ===========================================

# Instalação do Zinit se não existir
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  mkdir -p "$HOME/.zinit" && git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi
source "$HOME/.zinit/bin/zinit.zsh"

# ---------------------------
# Plugins
# ---------------------------

# Sugestões automáticas (digitação assistida)
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

# Melhorias de completions
zinit ice wait lucid
zinit light zsh-users/zsh-completions

# Busca no histórico estilo fish
zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

# ---------------------------
# ⚡ Precisa ser o último!
# ---------------------------
# Syntax highlighting → sempre carregar por último
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

