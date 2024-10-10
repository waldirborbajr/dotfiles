{ config, pkgs, ... }:
# let
#   # pkgsUnstable = import <nixpkgs-unstable> { };
#   # nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
# in 
{
  programs.go = { enable = true; };

  home = {
    packages = with pkgs; [
      # pkgsUnstable.go_1_23
      # (hiPrio go_1_23)
      air
      iferr
      delve
      go-outline
      go-symbols
      go-tools # staticcheck
      gocode-gomod
      godef
      gofumpt
      golangci-lint
      gomodifytags
      gopls
      goreleaser
      gotests
      gotools
      impl
      revive
    ];

    sessionVariables = {
      GOROOT = "${config.programs.go.package}/share/go";
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/bin";
    };
  };
}

