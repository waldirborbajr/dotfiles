# Functions

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

dokerzap() {
  # 1. Parar todos os containers
  docker stop $(docker ps -aq)

  # 2. Remover todos os containers
  docker rm $(docker ps -aq)

  # 3. Remover todas as imagens
  docker rmi $(docker images -q)

  # 4. Remover todos os volumes
  docker volume prune -f

  # 5. Remover todas as redes não utilizadas
  docker network prune -f

  # 6. Limpeza completa do sistema
  docker system prune -a -f --volumes
}

dockernew() {
  # Parar o serviço Docker completamente
  sudo systemctl stop docker

  # Remover todos os arquivos do Docker (EXTREMO - vai apagar TUDO)
  sudo rm -rf /var/lib/docker/*

  # Reiniciar o Docker
  sudo systemctl start docker
}

zl() { zellij list-sessions }
za() { zellij attach "$1" }
zs() { zellij -s "$1" }
zc() { rm -rf ~/.cache/zellij }

lzg() { command -v lazygit >/dev/null && lazygit }
lzq() { command -v lazysql >/dev/null && lazysql }
lzd() { command -v lazydocker >/dev/null && lazydocker }

# Atualiza nome da aba do Zellij dinamicamente
zellij_tab_name_update() {
  if [[ -n $ZELLIJ ]]; then
    tab_name=''
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
      tab_name+=$(git rev-parse --show-prefix)
      tab_name=${tab_name%/}
    else
      tab_name=$PWD
      if [[ $tab_name == $HOME ]]; then
        tab_name="~"
      else
        tab_name=${tab_name##*/}
      fi
    fi
    command nohup zellij action rename-tab "$tab_name" >/dev/null 2>&1
  fi
}

zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)

