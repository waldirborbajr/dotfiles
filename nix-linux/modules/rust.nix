
{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      rust-analyzer
      rustfmt
      # rustup
      cargo
      rustc
      rustfilt
      taplo # toml
      cargo-outdated
    ] ++ lib.lists.optionals pkgs.stdenv.isLinux (with pkgs; [
      # binutils now conflicts with clang as well, turning this off for now...
      # binutils # For some reason conflicts on darwin
      clang # Provides `cc` for any *-sys crates
    ]);

    sessionVariables = {
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUST_LOG = "debug";
      RUST_BACKTRACE = "full";
    };
  };
}
