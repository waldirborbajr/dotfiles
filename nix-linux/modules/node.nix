# {
#   pkgs,
#   ...
# }: {
#
#   home = {
#     packages = with pkgs; [
#       nodejs
#     ];
#
#     sessionVariables = {
#       NEXT_TELEMETRY_DISABLED = 1;
#     };
#   };
# }

{ config, pkgs, lib, ... }:

with lib;
let cfg = config.modules.dev.nodejs;
in {
  options.modules.dev.nodejs = { enable = mkEnableOption "nodejs"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ 
      nodejs-22_x 
      # bun
      # nodePackages.typescript-language-server
      # yarn
      # nodePackages.typescript
    ];

    home.file.".npmrc".source = ./npmrc;

    home.file.".npmrc".text = ''
      prefix = ${builtins.getEnv "HOME"}/.npm-packages
    '';
  };
}
