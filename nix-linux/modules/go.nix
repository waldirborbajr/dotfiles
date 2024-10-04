{
  config,
  pkgs,
  pkgs-unstable,
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
      # pkgs-unstable.golangci-lint
      # pkgs-unstable.golangci-lint-langserver
      # golangci-lint
      # golangci-lint-langserver
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
      GOROOT = "${pkgs.go}/share/go";
      # GOMODCACHE = "${config.xdg.cacheHome}/go/pkg/mod";
    };
  };
}
