{ pkgs, config, lib, ... }:

let
  # homeDirectory = if pkgs.stdenv.isLinux then "/home/borba" else "/Users/borba";

  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";

  # nvChad = import ./modules/nvchad.nix { inherit pkgs; };
in

{

  imports = [ 
    # ./modules/timezone.nix
    # ./modules/wezterm.nix
    ./modules/bat.nix
    ./modules/eza.nix
    ./modules/fzf.nix
    ./modules/gh.nix
    ./modules/git.nix
    ./modules/go.nix
    ./modules/nix.nix
    # ./modules/rust.nix
    ./modules/gpg.nix
    ./modules/htop.nix
    ./modules/lazygit.nix
    ./modules/obsidian.nix
    # ./modules/helix.nix
    ./modules/ripgrep.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/yazi.nix
    ./modules/zoxide.nix
  ];

  news.display = "show";

  fonts.fontconfig.enable = true;

  # shellAliases = {
  #   "pr" = "poetry run";
  #   "prpm" = "poetry run python3 manage.py";
  # };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "borba";
  # home.homeDirectory = "/home/borba";
  # home.homeDirectory = homeDirectory;

  home.username = username;
  home.homeDirectory = homedir;

  # Place the nvchad configuration in the right directory
  # home.file.".config/nvim" = {
  #   source = "${nvChad}/nvchad";
  #   recursive = true;  # copy files recursively
  # };

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
    # productivity
    tmux
    zellij
    obsidian
    # hugo # static site generator
    glow # markdown previewer in terminal

    bottom # btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # utils
    # file
    # which
    # tree
    # gnused
    # gnutar
    # gawk
    # zstd
    # gnupg
    # fastfetch
    moar
    # nnn # terminal file manager
    ripgrep # recursively searches directories for a regex pattern
    ripgrep-all
    jq # A lightweight and flexible command-line JSON processor
    # yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fd
    bat
    htop
    neofetch
    starship
    yazi

    # Git
    delta
    gh
    git-extras
    lazygit
    meld

    # nerdfonts
    # terminus-nerdfont
    # wezterm
    # zsh
    # Things that I really need

    gnupg
    neovim
    zoxide

    # Security
    nmap

    # Lua
    stylua
    sumneko-lua-language-server
    
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })

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

    ".config/home-manager".source = "${config.home.homeDirectory}/dotfiles/nix-linux";
    ".config/nix".source = "${config.home.homeDirectory}/dotfiles/nix";
    ".config/wezterm".source = "${config.home.homeDirectory}/dotfiles/wezterm";
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/";
      recursive = true;
    };
    ".ripgreprc".source = "${config.home.homeDirectory}/dotfiles/.ripgreprc";
    ".zimrc".source = "${config.home.homeDirectory}/dotfiles/.zimrc";
    ".zshenv".source = "${config.home.homeDirectory}/dotfiles/.zshenv";
    ".zshrc".source = "${config.home.homeDirectory}/dotfiles/zshrc/.zshrc";

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
    VISUAL = "nvim";

    # Language
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    # Nix
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_INSECURE = "1";

    # Term
    TERM = "xterm-256color";

    # XDG Setup
    XDG_CACHE_HOME = "$HOME/.cache";
    # XDG_CONFIG_DIRS = "/etc/xdg";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # GO
    # GOPATH = "$HOME/go";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  # enable experimental features
  nix = { 
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      auto-optimise-store = true;
    };
  };

  # set some environment variables that will ease usage of software
  # installed with nix on non-NixOS linux
  # (fixing local issues, settings XDG_DATA_DIRS, etc.):
  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.starship = import ./modules/starship.nix;
  # programs.gh = import ./modules/gh.nix;

}
