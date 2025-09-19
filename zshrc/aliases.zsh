# Aliases úteis
# alias ll='ls -la --color=auto'
alias ll="eza -lg --icons --group-directories-first"
alias la="eza -lag --icons --group-directories-first"
alias gs='git status'
alias dc='docker compose'
alias rmvim="rm -rf ~/.config/nvim ~/.local/state/nvim ~/.local/share/nvim"

# Transformei em função (mais seguro e legível)
syshealth() {
  echo "🧹 Limpando cache do apt/nala..."
  sudo rm -rf /var/lib/apt/lists/*
  sudo nala update
  sudo nala upgrade -y
  sudo nala autoremove -y
  sudo nala autopurge -y
  sudo nala clean

  echo "📦 Atualizando Flatpak e Snap..."
  flatpak update -y
  flatpak uninstall --unused -y
  sudo snap refresh

  echo "⚙️ Atualizando Cargo e Go..."
  cargo install-update -a
  go install
}
