{ ... }:

{
  home.file = {
    ".config/wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
