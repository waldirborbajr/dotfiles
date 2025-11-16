#!/usr/bin/env bash

# Set the package directory (current dir) and targets
PACKAGE_DIR="$(pwd)"
CONFIG_TARGET="$HOME/.config"
HOME_TARGET="$HOME"

# Function to check if stow is installed (optional, for robustness)
if ! command -v stow &>/dev/null; then
  echo "Error: Stow is not installed. Please install it first."
  exit 1
fi

# Step 1: Adopt from ~/.config into the package, ignoring .zshenv
echo "Adopting configs from $CONFIG_TARGET into $PACKAGE_DIR (ignoring .zshenv)..."
stow --adopt --target="$CONFIG_TARGET" --ignore='.zshenv' .

# Step 2: Manually adopt .zshenv from ~ into the package if it exists
if [ -f "$HOME_TARGET/.zshenv" ]; then
  echo "Adopting .zshenv from $HOME_TARGET into $PACKAGE_DIR..."
  cp "$HOME_TARGET/.zshenv" "$PACKAGE_DIR/.zshenv"
  echo ".zshenv adopted successfully."
else
  echo "No existing .zshenv found in $HOME_TARGET. Skipping adoption for .zshenv."
fi

# Step 3: Stow the package to ~/.config, ignoring .zshenv
echo "Stowing package to $CONFIG_TARGET (ignoring .zshenv)..."
stow --target="$CONFIG_TARGET" --ignore='.zshenv' .

# Step 4: Manually symlink .zshenv to ~
echo "Symlinking .zshenv to $HOME_TARGET..."
if [ -f "$PACKAGE_DIR/.zshenv" ]; then
  # Remove existing symlink or file if present (backup if it's a real file)
  if [ -L "$HOME_TARGET/.zshenv" ]; then
    rm "$HOME_TARGET/.zshenv"
  elif [ -f "$HOME_TARGET/.zshenv" ]; then
    mv "$HOME_TARGET/.zshenv" "$HOME_TARGET/.zshenv.bak"
    echo "Backed up existing .zshenv to .zshenv.bak."
  fi
  ln -s "$PACKAGE_DIR/.zshenv" "$HOME_TARGET/.zshenv"
  echo ".zshenv symlinked successfully."
else
  echo "No .zshenv found in package. Skipping symlink."
fi

echo "Initialization complete! Your dotfiles are now managed."
echo "Configs (except .zshenv) are in $CONFIG_TARGET."
echo ".zshenv is symlinked to $HOME_TARGET."
