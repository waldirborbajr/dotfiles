{ pkgs, lib, nixpkgs, ... }:
{


  home.file = {
    ".config/wezterm" = {
      source = ./wezterm2;
      recursive = true;
    };
  };

}
