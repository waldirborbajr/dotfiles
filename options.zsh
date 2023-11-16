
## History command configuration
setopt append_history
setopt share_history            # share history between sessions
setopt HIST_IGNORE_SPACE        # don't add commands with leading space to history
setopt extended_history         # record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST   # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS         # ignore duplicated commands history list
setopt hist_verify              # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY       # append into history file
setopt HIST_IGNORE_ALL_DUPS     # remove duplicate commands from history
setopt HIST_REDUCE_BLANKS       # Delete empty lines from history file
setopt HIST_NO_STORE            # Do not add history and fc commands to the history
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
SAVEHIST=1000
HISTSIZE=10000
HISTFILE=~/.cache/zsh/history
HIST_STAMPS="mm/dd/yyyy"

# DIRECTORY STACK
setopt auto_pushd               # automatically push previous directory to the stack
setopt pushd_ignore_dups        # ignore duplicates in directory stack
setopt pushd_minus              # swap + and -
setopt pushd_silent             # silend pushd and popd
setopt pushd_to_home            # pushd defaults to $HOME
DIRSTACKSIZE=12

# GENERAL
# setopt menu_complete            # insert first match of the completion
setopt list_packed              # fit more completions on the screen
setopt auto_cd                  # change directory by writing the directory name
setopt notify                   # report job status immediately
setopt no_flow_control          # disable flow control - Ctrl+S and Ctrl+Q keys
setopt interactive_comments     # allow comments
setopt noclobber                # >! or >| for existing files
