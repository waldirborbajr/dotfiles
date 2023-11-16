
# Create python virtual environment
function createVenv(){
  # dest="${PWD##*/}"
  dest="$1"

  if python3 -m venv "$dest" ; then
    cd "$dest"
    source "./bin/activate"
    [ ! -f "./requirements.txt" ] || pip install -r requirements.txt
  else
     echo "Failed to create 'venv' environment" >&2
  fi
}

# Download and Instlal GO
function getgo(){
  version="$1"
  wget https://go.dev/dl/go${version}.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz
}

# Clean system.
function clean-system () {
	rm -rf ~/.cache
}

# Choose Zellij Session
function zjsession() {
  ZJ_SESSIONS=$(zellij list-sessions)
  NO_SESSIONS=$(echo "${ZJ_SESSIONS}" | wc -l)

  if [ "${NO_SESSIONS}" -ge 2 ]; then
      zellij attach \
      "$(echo "${ZJ_SESSIONS}" | sk)"
  else
     zellij attach -c
  fi
}

# Restart a program.
function refresh () {
	killall $1
	$1 &
}
