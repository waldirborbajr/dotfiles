#!/usr/bin/env bash

#set -x
set -e
set -o pipefail

if (( $# < 2 )); then
  echo " installGO.sh [version] [target]"
  exit -1
fi

# INSTALL GOLANG ---------------------------------------------------------------

_VER=${1}
_TARGET=${2}

echo ${_VER} ${_TARGET}

case $_TARGET in
  "raspi64")
    GO="go${_VER}.linux-arm64.tar.gz"
  ;;
  "raspi32")
    GO="go${_VER}.linux-armv6l.tar.gz"
  ;;
  "linux")
    GO="go${_VER}.linux-amd64.tar.gz"
  ;;
  "mac")
    GO="go${_VER}.darwin-amd64.tar.gz"
  ;;
esac

echo ""
echo " starting download... " $GO
echo ""
echo ""
curl -LO https://go.dev/dl/$GO

if [ -d "/usr/local/go" ]; then
  echo ""
  echo "Removing old version ..."
  echo ""

  sudo rm -rf /usr/local/go
fi

echo ""
echo "Installing ... " $GO
echo ""

sudo tar -C /usr/local -xzf $GO

rm $GO
