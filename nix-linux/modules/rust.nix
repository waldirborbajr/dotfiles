
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
      cargo-outdated
      cargo-outdated
      cargo-semver-checks
      cargo-supply-chain
      cargo-sweep
      cargo-udeps
      cargo-udeps
      cargo-vet
      cargo-watch
      cargo-watch
      openssl
      rust-analyzer
      rustc
      rustfilt
      rustfmt
      taplo # toml
      wasm-bindgen-cli
    ] ++ lib.lists.optionals pkgs.stdenv.isLinux (with pkgs; [
      # binutils now conflicts with clang as well, turning this off for now...
      # binutils # For some reason conflicts on darwin
      clang # Provides `cc` for any *-sys crates
      # Common C tools
      cmake
      pkg-config
    ]);

    sessionVariables = {
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUST_LOG = "debug";
      RUST_BACKTRACE = 1;
      # Some crates disable nightly feature detection when this is set
      RUSTC_STAGE=1;
    };
  };
}
