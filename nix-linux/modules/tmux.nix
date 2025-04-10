
{ pkgs, lib, config, ... }:

# let
#   extraConfig = builtins.readFile ./tmux/tmux.conf;
# in
{
  programs.tmux = {
    enable = true;
    # inherit extraConfig;
  };

  home.file = {
    ".config/tmux" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux/";
      recursive = true;
    };

  };
}
