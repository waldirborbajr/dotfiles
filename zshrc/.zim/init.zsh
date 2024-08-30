if (( ${+ZIM_HOME} )) zimfw() { source "${HOME}/dotfiles/zshrc/.zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/dotfiles/zshrc/.zim/modules/git/functions" "${HOME}/dotfiles/zshrc/.zim/modules/utility/functions" "${HOME}/dotfiles/zshrc/.zim/modules/duration-info/functions" "${HOME}/dotfiles/zshrc/.zim/modules/git-info/functions" "${HOME}/dotfiles/zshrc/.zim/modules/zsh-completions/src" ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw duration-info-precmd duration-info-preexec coalesce git-action git-info
source "${HOME}/dotfiles/zshrc/.zim/modules/environment/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/git/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/input/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/termtitle/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/utility/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/duration-info/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/completion/init.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOME}/dotfiles/zshrc/.zim/modules/spaceship/spaceship.zsh"
