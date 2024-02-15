# History settings.
# export HISTFILE="${XDG_CACHE_HOME}/zsh/.history"
export HISTFILE=~/.zsh_history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=1000         # History lines stored in mememory.
export SAVEHIST=1000         # History lines stored on disk.
setopt INC_APPEND_HISTORY    # Immediately append commands to history file.
setopt HIST_IGNORE_ALL_DUPS  # Never add duplicate entries.
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space.
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blank lines.

# DIRECTORY STACK
setopt auto_pushd        # automatically push previous directory to the stack
setopt pushd_ignore_dups # ignore duplicates in directory stack
setopt pushd_minus       # swap + and -
setopt pushd_silent      # silend pushd and popd
setopt pushd_to_home     # pushd defaults to $HOME
DIRSTACKSIZE=12

# GENERAL
# setopt menu_complete            # insert first match of the completion
setopt list_packed          # fit more completions on the screen
setopt auto_cd              # change directory by writing the directory name
setopt notify               # report job status immediately
setopt no_flow_control      # disable flow control - Ctrl+S and Ctrl+Q keys
setopt interactive_comments # allow comments
setopt noclobber            # >! or >| for existing files

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='bold'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# zsh-autosuggestions settings.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Rust debug for tracing and other logging
export RUST_LOG=debug
