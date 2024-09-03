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
      ];
    tmux.enableShellIntegration = true;
    fileWidgetCommand = "fd --no-ignore --type f";
    fileWidgetOptions = [
      "--preview 'bat --color always {}'"
    ];
  };
}
