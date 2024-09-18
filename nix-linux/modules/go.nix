{
  config,
  pkgs,
  ...
}: {

  programs.go = {
    enable = true;
    package = pkgs.go_1_23;
  };

  home = {
    packages = with pkgs; [
      air
      delve
      go-tools # staticcheck
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      gotests
      gotestsum
      gotools # goimports
      impl
      revive
      sqlc
    ];

    sessionVariables = rec {
      GOPATH = "${config.xdg.dataHome}/go";
      GOBIN = "${GOPATH}/bin";
    };
  };
}
