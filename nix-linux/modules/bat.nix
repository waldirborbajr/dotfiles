{ ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      style = "numbers,changes,header,grid";
      italic-text = "always";
      pager = "less -FR";
      map-syntax = [ "h:cpp" ".ignore:.gitignore" ];
    };
  };
  home.shellAliases.cat = "bat";
  # "bat --theme=base16 --number --color=always --paging=never --tabs=2 --wrap=never";
}

