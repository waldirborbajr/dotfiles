{ config, pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "OneHalfDark";
      style = "numbers,changes,header,grid";
      italic-text = "always";
      pager = "less -FR";
      map-syntax = [ "h:cpp" ".ignore:.gitignore" ];
    };
  };
}

