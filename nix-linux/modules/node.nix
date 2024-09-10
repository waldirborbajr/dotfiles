{
  config,
  pkgs,
  ...
}: {

  programs.go = {
    enable = true;
  };

  home = {
    packages = with pkgs; [
      nodejs
    ];

    sessionVariables = {
      NEXT_TELEMETRY_DISABLED = 1;
    };
  };
}
