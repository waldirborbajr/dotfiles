{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stylua
    lua
    sumneko-lua-language-server # Lua.
    # shellcheck
    # shfmt
    # vale
  ];
}
