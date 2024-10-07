{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  home = {
    packages = with pkgs; [
      (hiPrio go_1_23)
      air
      delve
      go-outline
      go-symbols
      go-tools # staticcheck
      gocode-gomod
      godef
      gofumpt
      golang-perf
      golangci-lint
      gomodifytags
      gopls
      goreleaser
      gotests
      gotools
      impl
      pkgsUnstable.go_1_23
      revive
    ];

    sessionVariables = rec {
      GOPATH = "${config.xdg.dataHome}/go";
      GOBIN = "${GOPATH}/bin";
      GOROOT = "${pkgs.go}/share/go";
    };
  };
}

