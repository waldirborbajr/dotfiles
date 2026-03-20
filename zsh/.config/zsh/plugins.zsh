# Plugin loader otimizado

function plugin-load {
  local plugin repo commitsha plugdir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-~/.config/zsh}/plugins}

  for plugin in "$@"; do
    repo="$plugin"
    clone_args=(-q --depth 1 --recursive --shallow-submodules)

    if [[ "$plugin" == *'@'* ]]; then
      repo="${plugin%@*}"
      commitsha="${plugin#*@}"
      clone_args+=(--no-checkout)
    fi

    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh

    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone "${clone_args[@]}" https://github.com/$repo $plugdir

      if [[ -n "$commitsha" ]]; then
        git -C $plugdir fetch -q origin "$commitsha"
        git -C $plugdir checkout -q "$commitsha"
      fi
    fi

    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || continue
      ln -sf $initfiles[1] $initfile
    fi

    fpath+=$plugdir

    if (( $+functions[zsh-defer] )); then
      zsh-defer source $initfile
    else
      source $initfile
    fi
  done
}

repos=(
  'romkatv/zsh-defer'                      # performance absurda
  'zsh-users/zsh-completions'
  'zsh-users/zsh-autosuggestions'
  'zsh-users/zsh-syntax-highlighting'      # SEMPRE último
)

plugin-load $repos
