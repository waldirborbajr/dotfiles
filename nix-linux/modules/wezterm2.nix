{ pkgs, lib, nixpkgs, ... }:

# {
#   home.file = {
#     ".config/wezterm" = {
#       source = ./wezterm2;
#       recursive = true;
#     };
#   };
#
# }

let
  extraConfig = builtins.readFile ./wezterm2/wezterm.lua;
in
{
  programs.wezterm = {
    enable = true;
    inherit extraConfig;
  };
}
