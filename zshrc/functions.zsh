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
  go-global-update
}

pkgfix() {
  sudo nala install -f
  sudo dpkg --configure -a
}

dockerzap() {
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

chirp_update() {
  # Base URL for CHIRP daily builds
  CHIRP_BASE_URL="https://archive.chirpmyradio.com/chirp_next/"

  # Current version (based on provided filename)
  CURRENT_VERSION="20251010"

  # Check if CHIRP is installed with pip
  if ! pip list 2>/dev/null | grep -q "chirp"; then
    echo "CHIRP is not installed. Installing chirp-$CURRENT_VERSION-py3-none-any.whl..."
    # Download the specified .whl file
    curl -s -o "chirp-$CURRENT_VERSION-py3-none-any.whl" "${CHIRP_BASE_URL}next-$CURRENT_VERSION/chirp-$CURRENT_VERSION-py3-none-any.whl"
    if [ $? -eq 0 ]; then
      echo "Downloaded chirp-$CURRENT_VERSION-py3-none-any.whl"
      # Install using pip
      pip install --system-site-packages "chirp-$CURRENT_VERSION-py3-none-any.whl"
      if [ $? -eq 0 ]; then
        echo "Successfully installed chirp-$CURRENT_VERSION-py3-none-any.whl"
        # Clean up downloaded file
        rm -f "chirp-$CURRENT_VERSION-py3-none-any.whl"
      else
        echo "Error: Failed to install chirp-$CURRENT_VERSION-py3-none-any.whl"
        rm -f "chirp-$CURRENT_VERSION-py3-none-any.whl"
        return 1
      fi
    else
      echo "Error: Failed to download chirp-$CURRENT_VERSION-py3-none-any.whl"
      return 1
    fi
  else
    echo "CHIRP is already installed. Checking for updates..."
    
    # Try alternative method to get latest version
    LATEST_VERSION=$(curl -s "$CHIRP_BASE_URL" | grep -oE 'next-[0-9]{8}' | sed 's/next-//' | sort -nr | head -1)
    
    # Alternative method: check the directory listing more robustly
    if [ -z "$LATEST_VERSION" ]; then
      LATEST_VERSION=$(curl -s "$CHIRP_BASE_URL" | grep -oE '[0-9]{8}' | sort -nr | head -1)
    fi

    if [ -z "$LATEST_VERSION" ]; then
      echo "Error: Could not fetch latest CHIRP version. The website structure may have changed."
      echo "Please check manually at: $CHIRP_BASE_URL"
      return 1
    fi

    # Compare versions
    if [ "$LATEST_VERSION" -gt "$CURRENT_VERSION" ]; then
      echo "New version found: chirp-$LATEST_VERSION-py3-none-any.whl (current: chirp-$CURRENT_VERSION-py3-none-any.whl)"
      # Construct the URL for the latest .whl file
      LATEST_WHL_URL="${CHIRP_BASE_URL}next-${LATEST_VERSION}/chirp-${LATEST_VERSION}-py3-none-any.whl"
      LATEST_WHL="chirp-${LATEST_VERSION}-py3-none-any.whl"
      
      # Download the new .whl file
      curl -s -o "$LATEST_WHL" "$LATEST_WHL_URL"
      if [ $? -eq 0 ]; then
        echo "Downloaded $LATEST_WHL"
        # Upgrade using pip
        pip install --upgrade --force-reinstall "$LATEST_WHL"
        if [ $? -eq 0 ]; then
          echo "Successfully updated to $LATEST_WHL"
          # Clean up downloaded file
          rm -f "$LATEST_WHL"
        else
          echo "Error: Failed to install $LATEST_WHL"
          rm -f "$LATEST_WHL"
          return 1
        fi
      else
        echo "Error: Failed to download $LATEST_WHL_URL"
        return 1
      fi
    else
      echo "No newer version available. Current version ($CURRENT_VERSION) is up to date."
    fi
  fi
}

update_go() {
set -euf -o pipefail

# Fetch the latest stable Go version from https://go.dev/dl/
echo "Fetching the latest stable Go version..."
LATEST_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go\K[0-9]+\.[0-9]+(\.[0-9]+)?' | sort -V | tail -1)
if [[ -z "$LATEST_VERSION" ]]; then
  echo "Error: Could not fetch the latest Go version. Exiting."
  exit 1
fi
echo "Latest Go version available: ${LATEST_VERSION}"

# Check if Go is already installed and get its version
INSTALLED_VERSION=""
if command -v go &> /dev/null; then
  INSTALLED_VERSION=$(go version | grep -oP 'go\K[0-9]+\.[0-9]+(\.[0-9]+)?')
  echo "Installed Go version: ${INSTALLED_VERSION}"
else
  echo "No Go installation found."
fi

PLATFORM="linux-amd64" # Adjust if your system architecture is different (e.g., linux-arm64)

# Compare versions and skip if the installed version is the latest
if [[ "$INSTALLED_VERSION" == "$LATEST_VERSION" ]]; then
  echo "Go version ${LATEST_VERSION} is already installed and up to date."
  # Ensure environment variables are set even if we skip installation
  echo "Verifying Go environment variables..."
  PROFILE_FILE="$HOME/.zshrc"
  if ! grep -q "export PATH=\"\$PATH\":/usr/local/go/bin" "$PROFILE_FILE"; then
    echo "export PATH=\"\$PATH\":/usr/local/go/bin" >> "$PROFILE_FILE"
  fi
  if ! grep -q "export GOPATH=\$HOME/go" "$PROFILE_FILE"; then
    echo "export GOPATH=\$HOME/go" >> "$PROFILE_FILE"
  fi
  if ! grep -q "export PATH=\"\$PATH\":\$GOPATH/bin" "$PROFILE_FILE"; then
    echo "export PATH=\"\$PATH\":\$GOPATH/bin" >> "$PROFILE_FILE"
  fi
  source "$PROFILE_FILE"
  echo "Go environment variables verified."
  go version
  exit 0
fi

# Download the latest Go release if needed
echo "Downloading Go version ${LATEST_VERSION} for ${PLATFORM}..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
if ! curl -sL -o "go${LATEST_VERSION}.${PLATFORM}.tar.gz" "https://golang.org/dl/go${LATEST_VERSION}.${PLATFORM}.tar.gz"; then
  echo "Error: Failed to download Go. Check your internet connection or the version availability."
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Remove the old Go installation
echo "Removing old Go version..."
sudo rm -rf /usr/local/go

# Install the new Go version
echo "Installing new Go version..."
sudo tar -C /usr/local -xzf "go${LATEST_VERSION}.${PLATFORM}.tar.gz"

# Set up Go environment variables (if not already configured in your shell profile)
echo "Setting up Go environment variables..."
PROFILE_FILE="$HOME/.zshrc"
if ! grep -q "export PATH=\"\$PATH\":/usr/local/go/bin" "$PROFILE_FILE"; then
  echo "export PATH=\"\$PATH\":/usr/local/go/bin" >> "$PROFILE_FILE"
fi
if ! grep -q "export GOPATH=\$HOME/go" "$PROFILE_FILE"; then
  echo "export GOPATH=\$HOME/go" >> "$PROFILE_FILE"
fi
if ! grep -q "export PATH=\"\$PATH\":\$GOPATH/bin" "$PROFILE_FILE"; then
  echo "export PATH=\"\$PATH\":\$GOPATH/bin" >> "$PROFILE_FILE"
fi

# Source the profile to apply changes immediately
source "$PROFILE_FILE"

# Verify PATH includes Go bin
if [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
  echo "Warning: /usr/local/go/bin not in PATH. Restart your terminal or run 'source ~/.zshrc' manually."
else
  echo "PATH updated successfully."
fi

# Create the Go workspace directories if they don't exist
mkdir -p ~/go/{bin,pkg,src}

# Clean up downloaded archive
echo "Cleaning up downloaded files..."
cd "$HOME"  # Change back to home directory before cleanup
rm "go${LATEST_VERSION}.${PLATFORM}.tar.gz"
rmdir "$TEMP_DIR"

echo "Go update completed. Current Go version:"
if command -v go &> /dev/null; then
  go version
else
  echo "Go is installed but not yet in PATH. Run 'source ~/.zshrc' and try 'go version' again."
fi
}
