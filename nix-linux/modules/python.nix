{ config, pkgs, lib, ... }:

with lib;
let cfg = config.modules.dev.python;
in {
  options.modules.dev.python = { enable = mkEnableOption false; };
  
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ 
      python312 
      python312Packages.pip 
      pipenv 
      uv
    ];
  };
}
