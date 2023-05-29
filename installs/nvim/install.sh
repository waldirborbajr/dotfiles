#!/usr/bin/env bash

set -o errexit # (a.k.a. set -e)
set -o pipefail
set -o nounset # (a.k.a. set -u)
# set -o xtrace # (a.k.a set -x)

# INSTALL DEV DEPS ------------------------------------------------------------
sudo nala install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl git

rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim

rm -rf ~/.local/share/nvim 
rm -rf ~/.local/state/nvim 
rm -rf ~/.cache/nvim 


# DOWNLOAD SOURCE AND COMPILE -------------------------------------------------
if [ ! -d "neovim" ] && [ ! -d "luagit" ]; then
  git clone https://github.com/neovim/neovim
  git clone https://github.com/LuaJIT/LuaJIT
fi

if [[ -d "/usr/local/share/nvim" ]]; then
  sudo rm -rf /usr/local/share/nvim
fi

cd neovim

# Stable version uncomment the line below

# git checkout stable

make -j4 CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ..

rm -rf neovim
rm -rf LuaJIT

echo ""
exit

git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
cp bin/lua-language-server $HOME/.local/bin
cp bin/main.lua $HOME/.local
cd ..
rm -rf lua-language-server

