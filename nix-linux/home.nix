{ config, pkgs, ... }:

let
  homeDirectory = if pkgs.stdenv.isLinux then "/home/borba" else "/Users/borba";
in

{

  news.display = "show";

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "borba";
  # home.homeDirectory = "/home/borba";
  home.homeDirectory = homeDirectory;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
    bottom
    eza
    fd
    fzf
    gh
    git-extras
    htop
    lazygit
    neofetch
    neovim
    ripgrep
    ripgrep-all
    tmux
    yazi
    zellij
    # zsh

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "MesloLGS Nerd Font" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # To ensure we have the correct version of nix installed
    # config.nix.package
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    ".zshenv".source = ~/dotfiles/.zshenv;
    ".zimrc".source = ~/dotfiles/.zimrc;
    ".ripgreprc".source = ~/dotfiles/.ripgreprc;
    ".config/wezterm".source = ~/dotfiles/wezterm;
    ".config/tmux".source = ~/dotfiles/tmux;
    ".config/htop".source = ~/dotfiles/htop;
    ".config/lazygit".source = ~/dotfiles/lazygit;
    # ".config/git".source = ~/dotfiles/git;
    ".config/gh".source = ~/dotfiles/gh;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/yazi".source = ~/dotfiles/yazi;
    ".config/zellij".source = ~/dotfiles/zellij;
    ".config/home-manager".source = ~/dotfiles/nix-linux;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/borba/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  # enable experimental features
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    # settings.experimental-features = [ "nix-command" ];
  };

  # set some environment variables that will ease usage of software
  # installed with nix on non-NixOS linux
  # (fixing local issues, settings XDG_DATA_DIRS, etc.):
  targets.genericLinux.enable = true;

  # programs.wezterm = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   enableBashIntegration = true;
  #   # extraConfig = builtins.readFile ~/dotfiles/wezterm/wezterm.lua;
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Waldir Borba Junior";
    userEmail = "wborbajr@gmail.com";
    # delta.enable = true;
    lfs.enable = false;
    ignores = [
      "tags"
      ".vim.session"
      "tags.lock"
      "tags.temp"
      "ayak.sh"
      ".direnv"
    ];
    delta = {
      enable = true;
      # package = pkgs.delta;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };
    aliases = {
      ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      swc = "switch -c $1";
      swm = "switch main";
      co = "checkout";
      ci = "commit";
      cia = "commit --amend";
      s = "status";
      st = "status";
      b = "branch";
      p = "pull --rebase";
      pu = "push";
      d = "diff";
    };
    extraConfig = {
      color.ui = "true";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core.compression = 0;
      http.postBuffer = 1048576000;
      # protocol."https".allow = "always";
      # url."https://github.com/".insteadOf = [ "gh:" "github:" ];
      pull.rabase = "true";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  
  # programs.neovim.enable = true;

  # programs.zsh = {
  #   enable = true;
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  #
  #   initExtra = ''
  #   bindkey '^ ' autosuggest-accept
  #   unsetopt beep
  #   bindkey -e
  #
  #   autoload -Uz select-word-style
  #   select-word-style bash
  #
  #   source ~/.zsh/prompt.zsh
  #
  #   autoload -U edit-command-line
  #   zle -N edit-command-line
  #   bindkey '\C-x\C-e' edit-command-line
  #
  #   export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  #   # export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore "*.png" --ignore "*.jpg" --ignore "*.mp3" --ignore "*.import" --ignore "*.wav" --ignore "*.ogg" --ignore "*.aseprite" --ignore "*.ttf" --ignore "*.gif" --ignore "*.TTF" --ignore "*.afdesign" --ignore steam --ignore "*.afphoto" --ignore "*.tres" -l -g ""'
  #   # export FZF_DEFAULT_COMMAND='
  #   #   (git ls-tree -r --name-only HEAD ||
  #   #    find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
  #   #       sed s/^..//) 2> /dev/null'
  #
  #
  #   if [ -z "$VIM_VERSION" ]; then
  #     VIM_VERSION="nvim"
  #   fi
  #
  #   export EDITOR="$VIM_VERSION"
  #   export VISUAL="$VIM_VERSION"
  #
  #   alias vim="$VIM_VERSION"
  #   alias vi="vim"
  #
  #   stty sane
  #
  #   source ~/.zshrc.dot
  #   '';
  #
  #   # zplug = {
  #   #   enable = true;
  #   #   plugins= [
  #   #     {
  #   #       name = "ytet5uy4/fzf-widgets";
  #   #     }
  #   #     {
  #   #       name = "changyuheng/fz";
  #   #     }
  #   #     {
  #   #       name = "rupa/z";
  #   #     }
  #   #   ];
  #   # };
  #
  #   plugins = with pkgs; [
  #
  #   ];
  # };

}
