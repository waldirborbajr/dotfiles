# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
