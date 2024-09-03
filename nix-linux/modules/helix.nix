
{lib, pkgs, ...}:

{
  programs.helix = {
    enable = true;
    # defaultEditor = true;
    languages = {
      language = [
        # {
        #   name = "nix";
        #   language-servers = [ "nixd" ];
        # }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "alejandra";
          language-servers = ["nil"];
          indent.tab-width = 2;
          indent.unit = " ";
        }
        {
          name = "rust";
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "\t";
          };
        }
        {
          name = "go";
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "\t";
          };
        }
        {
          name = "markdown";
          auto-format = true;
          soft-wrap.enable = true;
          soft-wrap.wrap-at-text-width = true;
          language-servers = [
            "markdown-oxide"
            "ltex-ls"
          ];
        }
      ];
      language-server = {
        nixd.command = "${pkgs.nixd}/bin/nixd";
        markdown-oxide.command = "${pkgs.markdown-oxide}/bin/markdown-oxide";
        ltex-ls.command = "${pkgs.ltex-ls}/bin/ltex-ls";
      };
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "always";
        color-modes = true;
        cursor-shape.insert = "bar";
        cursor-shape.normal = "block";
        cursor-shape.select = "underline";
        indent-guides.render = true;
        indent-guides.character = "┊";
        indent-guides.skip-levels = 1;
        file-picker.hidden = false;
        shell = ["zsh" "-c"];
        scroll-lines = 6;
        completion-trigger-len = 2;
        text-width = 80;      
        auto-completion = true;
        auto-info = true;
        # bufferline = "multiple";
        lsp = { 
          display-messages = true;
          # display-inlay-hints = true;
        };
        soft-wrap = {
          enable = false;
          wrap-at-text-width = true;
        };
        true-color = true;
        whitespace.render = "all";
      };
      keys = {
        normal = {
          space = {
            W = ":toggle-option soft-wrap.enable";
            q = ":reflow";
          };
        };
        select = {
          space = {
            q = ":reflow";
          };
        };
        insert = {
          C-c   = "normal_mode";
          "C-[" = "normal_mode";
        };
      };
    };
  };
}
