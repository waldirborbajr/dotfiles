# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
#zinit light zsh-users/zsh-completions
#zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
#zinit snippet OMZP::archlinux
#zinit snippet OMZP::aws
#zinit snippet OMZP::kubectl
#zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Prompt
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^p' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

zle_highlight+=(paste:none)

# History
HISTSIZE=5000
HISTFILE=~/.local/share/zsh/history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Shell integrations
eval "$($HOME/.fzf/bin/fzf --zsh)"

# Zoxide integration
eval "$(zoxide init --cmd cd zsh)"

# Suffix Aliases
alias -s md="$EDITOR"
alias -s mov="open"
alias -s png="open"
alias -s mp4="open"
alias -s go="$EDITOR"
alias -s js="$EDITOR"
alias -s yaml="$EDITOR"
alias -s json="jq <"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------------------------------------------
# 👉 CUSTOM SOURCES
# -------------------------------------------
# source "$ZDOTDIR/exports.zsh"
#source "$ZDOTDIR/completion.zsh"
# source "$ZDOTDIR/functions.zsh"
#source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/hack.zsh"

#export ZSH_CUSTOM_PLUGINS="${ZDOTDIR}/plugins"

# -------------------------------------------
# 👉 5) AUTOSUGGESTIONS
# -------------------------------------------
#if [ -f "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
#  source "${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions/zsh-autosuggestions.zsh"
#  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a"
#  ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
#  ZSH_AUTOSUGGEST_USE_ASYNC=true
#  bindkey '^ ' autosuggest-accept
#fi

# -------------------------------------------
# 👉 6) CARAPACE
# -------------------------------------------
#if command -v carapace >/dev/null; then
#  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
#  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
#  source <(carapace _carapace)
#fi

# -------------------------------------------
# 👉 7) ATUIN
# -------------------------------------------
#export ATUIN_NOBIND="true"
#eval "$(atuin init zsh)"
#bindkey '^e' atuin-up-search-viins

# -------------------------------------------
# 👉 8) FZF + FD + PREVIEWS
# -------------------------------------------
# eval "$(fzf --zsh)"

# fg="#CBE0F0"
# bg="#011628"
# bg_highlight="#143652"
# purple="#B388FF"
# blue="#06BCE4"
# cpyan="#2CF9ED"

# export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }

# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }

# show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# _fzf_comprun() {
#   local command=$1
#   shift

#   case "$command" in
#     cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
#     export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
#     ssh)          fzf --preview 'dig {}' "$@" ;;
#     *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
#   esac
# }

# -------------------------------------------
# 👉 9) FZF-TAB (via zinit)
# -------------------------------------------
# zinit light Aloxaf/fzf-tab


# eza (better `ls`)
# ------------------------------------------------------------------------------
# if type eza &>/dev/null; then
#   alias l="eza --icons=always"
#   alias la="eza -a --icons=always"
#   alias lh="eza -ad --icons=always .*"
#   alias ll="eza -lg --icons=always"
#   alias lla="eza -lag --icons=always"
#   alias llh="eza -lagd --icons=always .*"
#   alias ls="eza --icons=always"
#   alias lt2="eza -lTg --level=2 --icons=always"
#   alias lt3="eza -lTg --level=3 --icons=always"
#   alias lt4="eza -lTg --level=4 --icons=always"
#   alias lt="eza -lTg --icons=always"
#   alias lta2="eza -lTag --level=2 --icons=always"
#   alias lta3="eza -lTag --level=3 --icons=always"
#   alias lta4="eza -lTag --level=4 --icons=always"
#   alias lta="eza -lTag --icons=always"
# else
#   echo ERROR: eza could not be found. Skip setting up eza aliases.
# fi

# zoxide (better `cd`)
# ------------------------------------------------------------------------------
# if type zoxide &>/dev/null; then
#   eval "$(zoxide init zsh --cmd cd)"
# else
#   echo ERROR: Could not load zoxide shell integration.
# fi
#
# -------------------------------------------
# 👉 10) UI: STARSHIP + ZOXIDE
# -------------------------------------------
# eval "$(starship init $(basename $SHELL))"
# eval "$(zoxide init zsh)"

# -------------------------------------------
# 👉 11) NODE/NVM
# -------------------------------------------
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# --- Integration with tmux & wezterm ---
# Automatic tmux attach on terminal start (unless nested or ssh)
# tmx

# --- Shell Keybindings (ZLE) ---
# bindkey -e
# bindkey "^[[1;3D" backward-word   # Alt + Left
# bindkey "^[[1;3C" forward-word    # Alt + Right
# bindkey "^[[1;3A" up-history      # Alt + Up
# bindkey "^[[1;3B" down-history    # Alt + Down

# --- Custom Starship theme ---
# export STARSHIP_CONFIG="$HOME/.config/starship-custom.toml"

microfetch

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
