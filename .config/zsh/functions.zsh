
# Create python virtual environment
createVenv(){
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
getgo(){
  version="$1"
  wget https://go.dev/dl/go${version}.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz
  sudo chown $(id -u):$(id -g) -R /usr/local/go/
  rm go${version}.linux-amd64.tar.gz
}

# Clean system.
clean-system () {
	rm -rf ~/.cache
}

# Choose Zellij Session
zjsession() {
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
refresh () {
	killall $1
	$1 &
}

fii() {
  [[ -n $1 ]] && cd $1 # go to provided folder or noop
  RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"

  selected=$(
  FZF_DEFAULT_COMMAND="rg --files" fzf \
    -m \
    -e \
    --ansi \
    --disabled \
    --reverse \
    --bind "ctrl-a:select-all" \
    --bind "f12:execute-silent:(subl -b {})" \
    --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
    --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
  )
  [[ -n $selected ]] && nvim $selected # open multiple files in editor
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}
