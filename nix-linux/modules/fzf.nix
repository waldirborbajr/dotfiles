# { config, pkgs, ... }:
#
# {
#   programs.fzf = {
#     enable = true;
#     enableZshIntegration = true;
#
#     defaultCommand = "fd -t f";
#   };
# }

{config, ...}: let
  dark =
    {
      github-light = false;
      solarized = false;
      catppuccin-latte = false;
    }
    .${config.me.theme}
    or true;
in {
  programs.fzf = {
    enable = true;
    # enableFishIntegration = true;
    enableZshIntegration = true;
    defaultCommand = ''rg --files --no-ignore --hidden --follow -g "!{.git,venv,node_modules}/*" 2> /dev/null'';
    defaultOptions =
      [
        "--tiebreak begin"
        "--ansi"
        "--no-mouse"
        "--tabstop 4"
        "--inline-info"
      ]
      ++ (
        if dark
        then ["--color dark"]
        else ["--color light"]
      );
    tmux.enableShellIntegration = true;
    fileWidgetCommand = "fd --no-ignore --type f";
    fileWidgetOptions = [
      "--preview 'bat --color always {}'"
    ];
  };
}
