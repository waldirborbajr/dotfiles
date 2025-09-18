# Functions

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

