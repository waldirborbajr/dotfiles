
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

