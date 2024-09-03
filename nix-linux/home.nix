{ pkgs, ... }:

let
  # homeDirectory = if pkgs.stdenv.isLinux then "/home/borba" else "/Users/borba";

  homedir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";
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
    ./modules/gpg.nix
    ./modules/htop.nix
    ./modules/lazygit.nix
    ./modules/obsidian.nix
    ./modules/helix.nix
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
    # nerdfonts
    # terminus-nerdfont
    # wezterm
    # zsh
    # Things that I really need
    bat
    bottom
    delta
    eza
    fd
    fzf
    gh
    git-extras
    helix
    htop
    lazygit
    meld
    neofetch
    neovim
    obsidian
    ripgrep
    ripgrep-all
    starship
    tmux
    yazi
    zellij
    zoxide
    # langservers / Formatters
    nil
    gopls # go
    rust-analyzer
    rustfmt
    taplo # toml
    lldb
    ltex-ls
    markdown-oxide
    # nixdo

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

    ".config/home-manager".source = ~/dotfiles/nix-linux;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/wezterm".source = ~/dotfiles/wezterm;
    ".ripgreprc".source = ~/dotfiles/.ripgreprc;
    ".zimrc".source = ~/dotfiles/.zimrc;
    ".zshenv".source = ~/dotfiles/.zshenv;
    ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    # ".config/tmux".source = ~/dotfiles/tmux;
    # ".config/yazi".source = ~/dotfiles/yazi;

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
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_INSECURE = "1";
    TERM = "xterm-256color";
    RUST_BACKTRACE = "full";
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
