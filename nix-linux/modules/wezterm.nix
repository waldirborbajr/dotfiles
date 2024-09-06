{ pkgs, lib, nixpkgs, ... }:

let
  extraConfig = builtins.readFile ./wezterm/wezterm.lua;
in
{
  programs.wezterm = {
    enable = true;
    inherit extraConfig;
  };
}

# {  pkgs, config, ... }: {
#   xdg.configFile."wezterm/wezterm.lua" = {
#     source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
#   };
# }
