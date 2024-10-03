{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    lua
    sumneko-lua-language-server # Lua.
    luarocks-nix
    # shellcheck
    # shfmt
    # vale
  ];
}
