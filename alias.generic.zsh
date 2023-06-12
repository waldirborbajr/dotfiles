# ----------------------------------------------------------------------------------
# Generic Aliases ------------------------------------------------------------------
# ----------------------------------------------------------------------------------

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

# unalias -a
alias '?'=searchOnDuck
alias '??'=searchOnGoogle
alias run-init-go="curl -so run https://gitlab.com/WaldirBorbaJR/run/-/raw/main/run-go && chmod +x run"
alias run='./run'
alias lf='lfcd'
alias lzg='lazygit'
alias lzd='lazydocker'
alias sx='sx 2>/dev/null'
alias gdb='gdb -q'
alias cl='clear'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias mkdir='mkdir -p'
alias chmox='chmod u+x'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias yank='yank -- xclip -selection clipboard'
alias hexdump='hexdump -C'
alias df='df -h'
alias dvi='doas nvim'
alias orphans='pacman -Qtdq | doas pacman -Rns -'
alias reboot='doas reboot'
alias poweroff='doas poweroff'
alias shutdown='doas shutdown'
alias xrdb-update='xrdb $HOME/.Xresources'
alias v='nvim'
alias reboot='sudo reboot'
alias halt='sudo halt -p'
alias off='sudo shutdown -p now'

# tmux aliases
alias tma='tmux attach'
alias tms='tmux ls'
alias tmt='tmux attach -t'
alias tmx='tmux new-session -s TmX'
alias tml='tmux list-sessions'
alias tmc='clear; tmux clear-history; clear'
alias tmd='tmux detach'
alias tmk='tmux kill-session'
alias tmks='tmux kill-server'

alias r='reset'
alias c='clear'
# alias syshealth='sudo nala update && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean && flatpak update && flatpak upgrade'
# alias syshealth='sudo nala update && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean'
alias du='du -hsx * | sort -rh | head -20'
# install tealdeer - tldr --update
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'

# use exa if available
if [[ -x "$(command -v exa)" ]]; then
  alias l='exa -l --icons -a'
  alias ls="exa --tree --level=2 --long --icons "
  # alias ll="exa --long --header --icons"
  alias ll="exa --long --all --classify --icons --git --ignore-glob='.git'"
else
  alias l="ls -lah ${colorflag}"
  alias ll="ls -lFh ${colorflag}"
fi
alias la="ls -AF ${colorflag}"
alias lld="ls -l | grep ^d"
alias rmf="rm -rf"

alias tree="ll --tree --level=4 -a -I=.git --git-ignore"

alias loc="wc -l"
alias mkvenv="python -m venv .venv"
alias tree="exa --tree --all --icons --ignore-glob='.git' --git-ignore"
alias dateiso="date +%Y-%m-%dT%H:%M:%S%z"
alias top="btop --utf-force"

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias http=xh

alias b='btm'

alias h='hx .'

alias s='source ~/.zshrc'

alias pf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"


## Zellij - alternative to TMUx
alias zj="zellij a -c 'B+ DevOps'"
alias zjrust="zellij --layout $HOME/.config/zellij/zelliRUST.kdl a -c 'B+ DevRust'"
alias zjgo="zellij --layout $HOME/.config/zellij/zelliGO.kdl a -c 'B+ DeviGO'"
alias zka="zellij ka -y"
alias zrn="zellij r -- $1"

# WZTern
alias wezterm='flatpak run org.wezfurlong.wezterm'

## Cargo
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ') --force"

## Nix
alias nsh="nix-shell --pure"
alias ngc="nix-collect-garbage"
alias nup="nix-env -u '*'"

## Clean NVim
alias rmvim="rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim  &&  rm -rf ~/.cache/nvim"

