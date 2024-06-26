
# Use modern completion system. Other than enabling globdots for showing
# hidden files, these ares values in the default generated zsh config.
autoload -Uz compinit
for dump in "$ZDOTDIR"/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
compinit
_comp_options+=(globdots)

# zstyle ':completion:*' menu select=2
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' format '%F{magenta}  %d %f'
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{yellow}  %d (errors: %e) %f'
zstyle ':completion:*:descriptions' format '%F{magenta}  %d %f'
zstyle ':completion:*:messages' format '%F{blue} 𥉉%d %f'
zstyle ':completion:*:warnings' format '%F{red}  No matches found... %f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
