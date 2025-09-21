#!/bin/bash

# Verifica se comando existe
check_installed() { command -v "$1" &>/dev/null; }

# Obtém arquivo de configuração do shell (respeita $ZDOTDIR)
get_shell_config() {
  case "$(basename "$SHELL")" in
  bash) echo "$HOME/.bashrc" ;;
  zsh) echo "${ZDOTDIR:-$HOME}/.zshrc" ;;
  *) echo "" ;;
  esac
}

# Configurações de shell (fzf, starship, carapace)
add_to_shell_config() {
  local line="$1" desc="$2"
  local cfg="$(get_shell_config)"
  [ -z "$cfg" ] && echo "Shell não suportado. Configure $desc manualmente." && return
  grep -qF "$line" "$cfg" 2>/dev/null || {
    echo "Configurando $desc..."
    echo -e "\n$line" >>"$cfg"
  }
}

# Dependências básicas
check_system_requirements() {
  for cmd in cargo git nala fc-cache; do
    if ! check_installed $cmd; then
      case $cmd in
      cargo)
        echo "Instale Rust antes de continuar: https://www.rust-lang.org/tools/install"
        exit 1
        ;;
      git) sudo apt update && sudo apt install -y git ;;
      nala) sudo apt update && sudo apt install -y nala ;;
      fc-cache) sudo nala install -y fontconfig ;;
      esac
    fi
  done
  if ! check_installed go; then sh ./installgo.sh && echo "Reinicie o terminal para continuar." && exit 1; fi
}

# Instalações via cargo/go
install_tools() {
  declare -A cargo_tools=(
    [fd]="fd-find" [rg]="ripgrep" [zoxide]="zoxide --locked"
    [bat]="bat" [eza]="eza" [yazi]="--force yazi-build"
    [cargo - install - update]="cargo-update" [starship]="starship --locked"
  )
  for bin in "${!cargo_tools[@]}"; do
    check_installed "$bin" || cargo install ${cargo_tools[$bin]}
  done

  check_installed fzf || {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all --no-update-rc
    add_to_shell_config '# fzf' "fzf"
  }
  check_installed lazysql || go install github.com/jorgerojas26/lazysql@latest
  check_installed lazygit || go install github.com/jesseduffield/lazygit@latest
  check_installed lazydocker || go install github.com/jesseduffield/lazydocker@latest
  check_installed hx || { sudo add-apt-repository ppa:maveonair/helix-editor -y && sudo nala update && sudo nala install -y helix; }
}

# Instala libs Go extras
install_go_libs() {
  for lib in \
    golang.org/x/tools/gopls \
    github.com/go-delve/delve/cmd/dlv \
    golang.org/x/tools/cmd/goimports \
    github.com/nametake/golangci-lint-langserver \
    github.com/golangci/golangci-lint/v2/cmd/golangci-lint; do
    go install "$lib@latest"
  done
}

# Instala fontes
install_fonts() {
  if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    mkdir -p "$HOME/.local/share/fonts"
    curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d "$HOME/.local/share/fonts" && rm /tmp/JetBrainsMono.zip
    fc-cache -fv
  fi
}

# Configura carapace
setup_carapace() {
  check_installed carapace || {
    echo "deb [trusted=yes] https://apt.fury.io/rsteube/ /" | sudo tee /etc/apt/sources.list.d/fury.list
    sudo nala update && sudo nala install -y carapace-bin
  }
  add_to_shell_config 'source <(carapace _carapace $(basename $SHELL))' "carapace"
}

# Execução
check_system_requirements
install_tools
install_go_libs
install_fonts
add_to_shell_config 'eval "$(starship init $(basename $SHELL))"' "starship"
setup_carapace

echo "✅ Todas as ferramentas foram instaladas e configuradas com sucesso!"
