
{ pkgs, lib, nixpkgs, ... }:

let
  extraConfig = builtins.readFile ./tmux/tmux.conf;
in
{
  programs.tmux = {
    enable = true;
    inherit extraConfig;
  };
}


# { pkgs, ... }: {
#   programs.tmux = {
#     enable = true;
#     extraConfig = builtins.readFile ./tmux.conf;
#     plugins = with pkgs.tmuxPlugins; [
#       catppuccin
#     ];
#   };
# }
