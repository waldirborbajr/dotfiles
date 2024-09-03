
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
