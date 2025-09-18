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

# Função para verificar e instalar dependências do sistema
check_system_requirements() {
  echo "Verificando dependências do sistema..."
  if ! command -v cargo &> /dev/null; then
    echo "Cargo não encontrado. Instale o Rust antes de continuar: https://www.rust-lang.org/tools/install"
    exit 1
  fi
  if ! command -v go &> /dev/null; then
    echo "Go não encontrado. Instale o Go antes de continuar: https://go.dev/doc/install"
    exit 1
  fi
  if ! command -v git &> /dev/null; then
    echo "Git não encontrado. Instalando git..."
    sudo nala install -y git || { echo "Falha ao instalar git"; exit 1; }
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

echo "Todas as ferramentas foram verificadas e instaladas com sucesso!"