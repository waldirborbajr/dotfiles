# rg: modern and fast grep
{ ... }: {
  programs.ripgrep = {
    enable = true;
    arguments = [ "--hidden" ];
  };
}
