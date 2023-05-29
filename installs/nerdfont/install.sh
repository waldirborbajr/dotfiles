#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

if (( $# < 1 )); then
  echo " install.sh 2.3.3"
  exit -1
fi

# mkdir $PWD/.fonts
if [ ! -d "$HOME/.local/share/fonts" ]; then
  mkdir -p $HOME/.local/share/fonts
fi

cd $HOME/.local/share/fonts

FONT_VERSION=${1}

declare -a FONTS=(
  3270.zip
  Agave.zip
  AnonymousPro.zip
  Arimo.zip
  AurulentSansMono.zip
  BigBlueTerminal.zip
  BitstreamVeraSansMono.zip
  CascadiaCode.zip
  IBMPlexMono.zip
  CodeNewRoman.zip
  Cousine.zip
  DaddyTimeMono.zip
  DejaVuSansMono.zip
  DroidSansMono.zip
  FantasqueSansMono.zip
  FiraCode.zip
  FiraMono.zip
  Go-Mono.zip
  Gohu.zip
  Hack.zip
  Hasklig.zip
  HeavyData.zip
  Hermit.zip
  iA-Writer.zip
  Inconsolata.zip
  InconsolataGo.zip
  InconsolataLGC.zip
  Iosevka.zip
  JetBrainsMono.zip
  Lekton.zip
  LiberationMono.zip
  Lilex.zip
  Meslo.zip
  Monofur.zip
  Monoid.zip
  Mononoki.zip
  MPlus.zip
  Noto.zip
  ProFont.zip
  ProggyClean.zip
  OpenDyslexic.zip
  Overpass.zip
  RobotoMono.zip
  ShareTechMono.zip
  SourceCodePro.zip
  SpaceMono.zip
  NerdFontsSymbolsOnly.zip
  Terminus.zip
  Tinos.zip
  Ubuntu.zip
  UbuntuMono.zip
  VictorMono.zip
)

for FONT in "${FONTS[@]}"; 
do
  echo ""
  echo "-------- downloading -------: ${FONT}"
  echo ""
  if [[ ! -f "${FONT}" ]]; then
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/${FONT}
  fi
  echo "-------- done -------"
done

curl -LO https://github.com/googlefonts/noto-emoji/blob/main/fonts/NotoColorEmoji.ttf
curl -LO https://github.com/microsoft/vscode-codicons/raw/main/dist/codicon.ttf

for FONT in "${FONTS[@]}"; 
do
  unzip -o "${FONT}"
done

rm -rf *Windows*

rm -rf *.zip

fc-cache -f -v

