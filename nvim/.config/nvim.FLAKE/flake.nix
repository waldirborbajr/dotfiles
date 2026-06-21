{
  description = "Neovim with LSP dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux"; # change if needed
      pkgs = import nixpkgs { inherit system; };
      pkgList = with pkgs; [
        # LSPs
        lua-language-server
        vscode-langservers-extracted
        emmet-language-server
        svelte-language-server
        rust-analyzer
        ast-grep
        prettier
        black
        nixfmt
        rustfmt
        nil
        python313Packages.python-lsp-server
        typescript-language-server
        tailwindcss-language-server
        stylua
        nixd

        # other tools
        lua5_1
        tree-sitter
        ripgrep
        gcc
        fzf
        gnumake
        imagemagick
        luarocks
      ];

      nvimRemoteConfig = pkgs.runCommand "nvim-remote-config" { } ''
        mkdir -p $out/nvim-remote
        cp ${./init.lua} $out/nvim-remote/init.lua
        cp -r ${./lua} $out/nvim-remote/lua
      '';

      mkWrappedNvim =
        {
          name,
          extraWrapArgs ? "",
        }:
        pkgs.symlinkJoin {
          inherit name;
          paths = [ pkgs.neovim ];
          buildInputs = [ pkgs.makeWrapper ];
          meta.mainProgram = "nvim";
          postBuild = ''
            wrapProgram $out/bin/nvim \
              --prefix PATH : ${pkgs.lib.makeBinPath pkgList} \
              --set TREE_SITTER_LIB_PATH "${pkgs.tree-sitter}/lib" \
              ${extraWrapArgs}
          '';
        };

      nvim-wrapped = mkWrappedNvim { name = "nvim"; };

      nvim-remote = mkWrappedNvim {
        name = "nvim-remote";
        extraWrapArgs = ''
          --set NVIM_APPNAME "nvim-remote" \
          --set XDG_CONFIG_HOME "${nvimRemoteConfig}"
        '';
      };
    in
    {
      packages.${system} = {
        default = nvim-wrapped;
        remote = nvim-remote;
      };

      devShells.${system}.default = pkgs.mkShell {

        packages = [
          nvim-wrapped
        ];

        shellHook = ''
          export TREE_SITTER_LIB_PATH="${pkgs.tree-sitter}/lib"
          export DEVSHELL_NAME="󱄅 flake/#89dceb| neovim/green"
        '';
      };
    };
}
