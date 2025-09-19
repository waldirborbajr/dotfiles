#!/bin/bash

# Função para verificar se um comando está instalado
check_installed() {
  if command -v "$1" &> /dev/null; then
    echo "$1 já está instalado."
    return 0
  else
    echo "$1 não está instalado. Instalando..."
    return 1
  fi
}

# Função para verificar se uma fonte está instalada
check_font_installed() {
  if fc-list | grep -qi "$1"; then
    echo "A fonte $1 já está instalada."
    return 0
  else
    echo "A fonte $1 não está instalada. Instalando..."
    return 1
  fi
}

# Função para verificar e instalar dependências do sistema
check_system_requirements() {
  echo "Verificando dependências do sistema..."
  if ! command -v cargo &> /dev/null; then
    echo "Cargo não encontrado. Instale o Rust antes de continuar: https://www.rust-lang.org/tools/install"
    exit 1
  fi
  if ! command -v go &> /dev/null; then
    sh ./installgo.sh
    echo "Reinitcie o terminal para continuar a instalação"
    # echo "Go não encontrado. Instale o Go antes de continuar: https://go.dev/doc/install"
    exit 1
  fi
  if ! command -v git &> /dev/null; then
    echo "Git não encontrado. Instalando git..."
    sudo apt update || { echo "Falha ao atualizar pacotes com apt"; exit 1; }
    sudo apt install -y git || { echo "Falha ao instalar git"; exit 1; }
  fi
  if ! command -v nala &> /dev/null; then
    echo "Nala não encontrado. Instalando nala..."
    sudo apt update || { echo "Falha ao atualizar pacotes com apt"; exit 1; }
    sudo apt install -y nala || { echo "Falha ao instalar nala"; exit 1; }
  fi
  if ! command -v fc-cache &> /dev/null; then
    echo "fontconfig não encontrado. Instalando fontconfig..."
    sudo nala install -y fontconfig || { echo "Falha ao instalar fontconfig"; exit 1; }
  fi
}

# Função para configurar fzf no shell padrão
configure_fzf() {
  echo "Configurando fzf no shell padrão..."
  # Detectar o shell padrão
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    *)
      echo "Shell $SHELL_NAME não suportado para configuração automática. Configure o fzf manualmente."
      return 1
      ;;
  esac

  # Adicionar ~/.fzf/bin ao PATH, se não estiver presente
  FZF_PATH="$HOME/.fzf/bin"
  if grep -q "$FZF_PATH" "$SHELL_CONFIG" 2>/dev/null; then
    echo "O diretório $FZF_PATH já está no PATH em $SHELL_CONFIG."
  else
    echo "Adicionando $FZF_PATH ao PATH em $SHELL_CONFIG..."
    {
      echo ""
      echo "# Adicionando fzf ao PATH"
      echo 'export PATH="$PATH:'"$FZF_PATH"'"'
    } >> "$SHELL_CONFIG" || { echo "Falha ao adicionar $FZF_PATH ao PATH em $SHELL_CONFIG"; return 1; }
  fi

  # Verificar se o fzf já está configurado no arquivo
  if grep -q "fzf/shell" "$SHELL_CONFIG" 2>/dev/null; then
    echo "Configurações de completion e key-bindings do fzf já estão em $SHELL_CONFIG."
  else
    echo "Adicionando configurações de completion e key-bindings do fzf em $SHELL_CONFIG..."
    {
      echo ""
      echo "# Configuração do fzf"
      echo '[ -f ~/.fzf/shell/completion.'"$SHELL_NAME"' ] && source ~/.fzf/shell/completion.'"$SHELL_NAME"''
      echo '[ -f ~/.fzf/shell/key-bindings.'"$SHELL_NAME"' ] && source ~/.fzf/shell/key-bindings.'"$SHELL_NAME"''
    } >> "$SHELL_CONFIG" || { echo "Falha ao adicionar configurações do fzf em $SHELL_CONFIG"; return 1; }
  fi
  echo "Configuração do fzf concluída com sucesso!"
}

# Função para configurar starship no shell padrão
configure_starship() {
  echo "Configurando starship no shell padrão..."
  # Detectar o shell padrão
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    *)
      echo "Shell $SHELL_NAME não suportado para configuração automática. Configure o starship manualmente."
      return 1
      ;;
  esac

  # Verificar se o starship já está configurado no arquivo
  if grep -q "starship init" "$SHELL_CONFIG" 2>/dev/null; then
    echo "Configuração do starship já está em $SHELL_CONFIG."
  else
    echo "Adicionando configuração do starship em $SHELL_CONFIG..."
    {
      echo ""
      echo "# Configuração do starship"
      echo 'eval "$(starship init '"$SHELL_NAME"')"'
    } >> "$SHELL_CONFIG" || { echo "Falha ao adicionar configuração do starship em $SHELL_CONFIG"; return 1; }
  fi
  echo "Configuração do starship concluída com sucesso!"
}

# Função para configurar carapace no shell padrão
configure_carapace() {
  echo "Configurando carapace no shell padrão..."
  # Detectar o shell padrão
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    *)
      echo "Shell $SHELL_NAME não suportado para configuração automática. Configure o carapace manualmente."
      return 1
      ;;
  esac

  # Verificar se o carapace já está configurado no arquivo
  if grep -q "carapace _carapace" "$SHELL_CONFIG" 2>/dev/null; then
    echo "Configuração do carapace já está em $SHELL_CONFIG."
  else
    echo "Adicionando configuração do carapace em $SHELL_CONFIG..."
    {
      echo ""
      echo "# Configuração do carapace"
      echo 'source <(carapace _carapace '"$SHELL_NAME"')'
    } >> "$SHELL_CONFIG" || { echo "Falha ao adicionar configuração do carapace em $SHELL_CONFIG"; return 1; }
  fi
  echo "Configuração do carapace concluída com sucesso!"
}

# Função para adicionar repositório do carapace
add_carapace_repository() {
  echo "Adicionando repositório do carapace..."
  REPO_LINE="deb [trusted=yes] https://apt.fury.io/rsteube/ /"
  SOURCES_DIR="/etc/apt/sources.list.d"
  CARAPACE_SOURCE="$SOURCES_DIR/fury.list"
  if [ -f "$CARAPACE_SOURCE" ] && grep -Fx "$REPO_LINE" "$CARAPACE_SOURCE" > /dev/null; then
    echo "Repositório do carapace já está configurado em $CARAPACE_SOURCE."
  else
    echo "Adicionando repositório do carapace em $CARAPACE_SOURCE..."
    sudo mkdir -p "$SOURCES_DIR" || { echo "Falha ao criar diretório $SOURCES_DIR"; exit 1; }
    echo "$REPO_LINE" | sudo tee "$CARAPACE_SOURCE" > /dev/null || { echo "Falha ao adicionar repositório do carapace"; exit 1; }
  fi
}

# Função para instalar JetBrains Mono Nerd Font
install_jetbrains_mono_nerd_font() {
  if ! check_font_installed "JetBrainsMono Nerd Font"; then
    echo "Baixando JetBrains Mono Nerd Font..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR" || { echo "Falha ao criar diretório $FONT_DIR"; exit 1; }
    FONT_ZIP="$FONT_DIR/JetBrainsMono.zip"
    curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$FONT_ZIP" || { echo "Falha ao baixar JetBrains Mono Nerd Font"; exit 1; }
    unzip -o "$FONT_ZIP" -d "$FONT_DIR" || { echo "Falha ao descompactar JetBrains Mono Nerd Font"; exit 1; }
    rm "$FONT_ZIP" || { echo "Falha ao remover arquivo zip"; exit 1; }
    echo "Atualizando cache de fontes..."
    fc-cache -fv || { echo "Falha ao atualizar cache de fontes"; exit 1; }
    echo "JetBrains Mono Nerd Font instalado com sucesso!"
  fi
}

# Iniciar verificação de dependências
check_system_requirements

# Instalar fd-find
if ! check_installed fd; then
  cargo install fd-find || { echo "Falha ao instalar fd-find"; exit 1; }
fi

# Instalar ripgrep
if ! check_installed rg; then
  cargo install ripgrep || { echo "Falha ao instalar ripgrep"; exit 1; }
fi

# Instalar zoxide
if ! check_installed zoxide; then
  cargo install zoxide --locked || { echo "Falha ao instalar zoxide"; exit 1; }
fi

# Instalar bat
if ! check_installed bat; then
  cargo install bat || { echo "Falha ao instalar bat"; exit 1; }
fi

# Instalar yazi
if ! check_installed yazi; then
  cargo install --force yazi-build || { echo "Falha ao instalar yazi"; exit 1; }
fi

# Instalar cargo-update
if ! check_installed cargo-install-update; then
  cargo install cargo-update || { echo "Falha ao instalar cargo-update"; exit 1; }
fi

# Instalar fzf
if ! check_installed fzf; then
  echo "Clonando e instalando fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || { echo "Falha ao clonar fzf"; exit 1; }
  ~/.fzf/install --all --no-update-rc || { echo "Falha ao instalar fzf"; exit 1; }
  configure_fzf || { echo "Falha ao configurar fzf"; exit 1; }
fi

# Instalar LazySQL
if ! check_installed lazysql; then
  go install github.com/jorgerojas26/lazysql@latest || { echo "Falha ao instalar lazysql"; exit 1; }
fi

# Instalar LazyGit
if ! check_installed lazygit; then
  go install github.com/jesseduffield/lazygit@latest || { echo "Falha ao instalar lazygit"; exit 1; }
fi

# Instalar LazyDocker
if ! check_installed lazydocker; then
  go install github.com/jesseduffield/lazydocker@latest || { echo "Falha ao instalar lazydocker"; exit 1; }
fi

# Instalar helix
if ! check_installed hx; then
  echo "Adicionando repositório do Helix e instalando..."
  sudo add-apt-repository ppa:maveonair/helix-editor -y || { echo "Falha ao adicionar repositório do Helix"; exit 1; }
  sudo nala update || { echo "Falha ao atualizar pacotes"; exit 1; }
  sudo nala install -y helix || { echo "Falha ao instalar helix"; exit 1; }
fi

# Instalar JetBrains Mono Nerd Font
install_jetbrains_mono_nerd_font

# Instalar starship
if ! check_installed starship; then
  cargo install starship --locked || { echo "Falha ao instalar starship"; exit 1; }
  configure_starship || { echo "Falha ao configurar starship"; exit 1; }
fi

# Instalar carapace
if ! check_installed carapace; then
  add_carapace_repository
  sudo nala update || { echo "Falha ao atualizar pacotes"; exit 1; }
  sudo nala install -y carapace-bin || { echo "Falha ao instalar carapace-bin"; exit 1; }
  configure_carapace || { echo "Falha ao configurar carapace"; exit 1; }
fi

echo "Todas as ferramentas e fontes foram verificadas, instaladas e configuradas com sucesso!"
