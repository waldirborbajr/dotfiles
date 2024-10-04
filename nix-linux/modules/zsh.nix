{ pkgs, config, ... }: {
  programs.zsh = {

    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    # syntaxHighlighting.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters =
        [ "main" "brackets" "pattern" "cursor" "regexp" "root" "line" ];
    };

    dotDir = ".config/zsh";

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 512 * 1024 * 1024; # Save more.
      size = 512 * 1024 * 1024; # Save more.
      share = true;
    };

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      LC_ALL = "en_US.UTF-8";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      dstop = "docker stop $(docker ps -a -q)";
      dclean = "docker rm $(docker ps -a -q)";
      dclear = "docker rmi --force $(docker images -q)";
      cat =
        "bat --theme=base16 --number --color=always --paging=never --tabs=2 --wrap=never";
      vim = "nvim";
      ls = "ls --color";
      ctrl-l = "clear";
      C-l = "ctrl-l";
      control-l = "clear";
      clean = "clear";
      hm = "home-manager";
      hmd = "cd ~/dotfiles/nix-linux/";
      hmb = "home-manager -f home.nix build";
      hms = "home-manager -f home.nix switch";
      hmsf =
        "home-manager switch --flake ~/dotfiles/nix-linux/home-manager#borba";
      hmp = "home-manager packages";
      hmu = "nix flake update ~/dotfiles/nix-linux && hms";
      hmg = "home-manager generations";
      nxu = "nix-channel --update";
      ngc =
        "nix-store --gc && nix-collect-garbage -d && home-manager expire-generations '-2 days' && zimfw clean";
      gg = "lazygit";
      syshealth =
        "sudo nala update && sudo rm /var/lib/apt/lists/lock && sudo nala upgrade -y && sudo nala autoremove -y && sudo nala autopurge -y && sudo nala clean && flatpak update -y && flatpak uninstall --unused -y && sudo snap refresh";
      tmk = "tmux kill-session -a"; # clear clipboard
      tmks = "tmux kill-server";
    };

    # -----------------------
    initExtraBeforeCompInit = ''
      fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
    '';

    completionInit = ''
      # Load Zsh modules
      zmodload zsh/zle
      zmodload zsh/zpty
      zmodload zsh/complist

      # Initialize colors
      autoload -Uz colors
      colors

      # Initialize completion system
      autoload -U compinit
      compinit
      _comp_options+=(globdots)

      # Load edit-command-line for ZLE
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      # General completion behavior
      zstyle ':completion:*' completer _extensions _complete _approximate

      # Use cache
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      # Complete the alias
      zstyle ':completion:*' complete true

      # Autocomplete options
      zstyle ':completion:*' complete-options true

      # Completion matching control
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' keep-prefix true

      # Group matches and describe
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-grouped false
      zstyle ':completion:*' list-separator '''
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
      zstyle ':completion:*:descriptions' format '[%d]'

      # Colors
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Directories
      zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
      zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
      zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
      zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' squeeze-slashes true

      # Sort
      zstyle ':completion:*' sort false
      zstyle ":completion:*:git-checkout:*" sort false
      zstyle ':completion:*' file-sort modification
      zstyle ':completion:*:eza' sort false
      zstyle ':completion:complete:*:options' sort false
      zstyle ':completion:files' sort false

      # fzf-tab
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview $realpath'
      zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
      zstyle ':fzf-tab:*' fzf-command fzf
      zstyle ':fzf-tab:*' fzf-pad 4
      zstyle ':fzf-tab:*' fzf-min-height 100
      zstyle ':fzf-tab:*' switch-group ',' '.'
    '';
    # ---------------------------

    initExtra = ''
      export EDITOR=nvim

      if [ -n "$TTY" ]; then
        export GPG_TTY=$(tty)
      else
        export GPG_TTY="$TTY"
      fi

      # SSH_AUTH_SOCK set to GPG to enable using gpgagent as the ssh agent.
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent

      bindkey -e

      bindkey '^[w' kill-region

      zle_highlight+=(paste:none)

      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups

      # Force UTF-8
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      # Set fzf options
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --no-ignore"
      export FZF_DEFAULT_OPTS='--bind ctrl-y:preview-up,ctrl-e:preview-down,left:toggle+up,right:toggle+down'
      export FZF_DEFAULT_OPTS=" \
      --multi \
      --cycle \
      --reverse \
      --bind='ctrl-space:toggle,pgup:preview-up,pgdn:preview-down' \
      --ansi \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 
      "

      eval "$(zoxide init zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "command-not-found"
        "docker"
        "docker-compose"
        "git"
        "golang"
        "helm"
        "kubectl"
        "kubectx"
        "pass"
        "rust"
        "starship"
        "sudo"
        "tmux"
        "z"
      ];
    };

    # Plugins not natively supported by home-manager.
    # These will git cloned and sourced, so there is little overhead.
    plugins = with pkgs; [{
      name = "zsh-autopair";
      src = fetchFromGitHub {
        owner = "hlissner";
        repo = "zsh-autopair";
        rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
        sha256 = "PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
      };
      file = "autopair.zsh";
    }];

  };
}
