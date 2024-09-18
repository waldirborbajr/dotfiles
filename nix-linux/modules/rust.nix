{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      # cargo-dl
      # cargo-doc-like-docs-rs
      # cargo-minimal-versions
      # cargo-rubber
      # cargo-upgrade
      # rustup
      bacon
      cargo
      cargo-asm
      cargo-audit
      cargo-deny
      cargo-expand
      cargo-expand
      cargo-flamegraph
      cargo-fuzz
      cargo-hack
      cargo-insta
      cargo-license
      cargo-make
      cargo-nextest
      cargo-outdated
      cargo-semver-checks
      cargo-supply-chain
      cargo-sweep
      cargo-udeps
      cargo-vet
      cargo-watch
      clippy
      openssl
      pkg-config
      rust-analyzer
      rustc
      rustfilt
      rustfmt
      taplo # toml
      udev
      wasm-bindgen-cli
    ] ++ lib.lists.optionals pkgs.stdenv.isLinux (with pkgs; [
      # binutils now conflicts with clang as well, turning this off for now...
      # binutils # For some reason conflicts on darwin
      clang # Provides `cc` for any *-sys crates
      # Common C tools
      cmake
    ]);

    sessionVariables = {
      # CARGO_HOME = "$HOME/.cargo";
      # RUST_BACKTRACE = 1;
      # RUSTUP_HOME = "$HOME/.rustup";
      # PATH = "$CARGO_HOME/bin:$PATH";
      PKG_CONFIG_PATH = "${pkgs.systemd.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
      RUSTUP_HOME = "${config.xdg.dataHome}/.rustup";
      CARGO_HOME = "${config.xdg.dataHome}/.cargo";
      PATH = "$CARGO_HOME/bin:$PATH";
      RUST_LOG = "debug";
      RUST_BACKTRACE = 1;
    };
  };
}

