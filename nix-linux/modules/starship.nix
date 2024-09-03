# https://nix-community.github.io/home-manager/options.html#opt-programs.starship.enable

{
  config,
  pkgs,
  ...
}: let
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
  os = icon: fg: "[${icon} ](fg:${fg})";
  pad = {
    left = "";
    right = "";
  };
  settings = {
    add_newline = true;
    format = builtins.concatStringsSep "" [
      "$nix_shell"
      "$os"
      "$directory"
      "$container"
      "$git_branch $git_status"
      "$python"
      "$nodejs"
      "$lua"
      "$rust"
      "$java"
      "$c"
      "$golang"
      "$cmd_duration"
      "$status"
      "$line_break"
      "[❯](bold purple)"
      ''''${custom.space}''
    ];
    custom.space = {
      when = ''! test $env'';
      format = "  ";
    };
    continuation_prompt = "∙  ┆ ";
    line_break = {disabled = false;};
    status = {
      symbol = "✗";
      not_found_symbol = "󰍉 Not Found";
      not_executable_symbol = " Can't Execute E";
      sigint_symbol = "󰂭 ";
      signal_symbol = "󱑽 ";
      success_symbol = "";
      format = "[$symbol](fg:red)";
      map_symbol = true;
      disabled = false;
    };
    cmd_duration = {
      min_time = 1000;
      format = "[$duration ](fg:yellow)";
    };
    nix_shell = {
      disabled = false;
      format = "[${pad.left}](fg:white)[ ](bg:white fg:black)[${pad.right}](fg:white) ";
    };
    container = {
      symbol = " 󰏖";
      format = "[$symbol ](yellow dimmed)";
    };
    directory = {
      format = builtins.concatStringsSep "" [
        " [${pad.left}](fg:bright-black)"
        "[$path](bg:bright-black fg:white)"
        "[${pad.right}](fg:bright-black)"
        " [$read_only](fg:yellow)"
      ];
      read_only = " ";
      truncate_to_repo = true;
      truncation_length = 4;
      truncation_symbol = "";
    };
    git_branch = {
      symbol = "";
      style = "";
      format = "[ $symbol $branch](fg:purple)(:$remote_branch)";
    };
    os = {
      disabled = false;
      format = "$symbol";
    };
    os.symbols = {
      Arch = os "" "bright-blue";
      Alpine = os "" "bright-blue";
      Debian = os "" "red)";
      EndeavourOS = os "" "purple";
      Fedora = os "" "blue";
      NixOS = os "" "blue";
      openSUSE = os "" "green";
      SUSE = os "" "green";
      Ubuntu = os "" "bright-purple";
      Macos = os "" "white";
    };
    python = lang "" "yellow";
    nodejs = lang "󰛦" "bright-blue";
    bun = lang "󰛦" "blue";
    deno = lang "󰛦" "blue";
    lua = lang "󰢱" "blue";
    rust = lang "" "red";
    java = lang "" "red";
    c = lang "" "blue";
    golang = lang "" "blue";
    dart = lang "" "blue";
    elixir = lang "" "purple";
  };
  tomlFormat = pkgs.formats.toml {};
  starshipCmd = "${pkgs.starship}/bin/starship";
in {
  xdg.configFile."starship.toml" = {
    source = tomlFormat.generate "starship-config" settings;
  };

  programs.bash.initExtra = ''
    eval "$(${starshipCmd} init bash)"
  '';

  programs.zsh.initExtra = ''
    eval "$(${starshipCmd} init zsh)"
  '';

  programs.nushell = {
    extraEnv = ''
      mkdir ${config.xdg.cacheHome}/starship
      ${starshipCmd} init nu | save -f ${config.xdg.cacheHome}/starship/init.nu
    '';
    extraConfig = ''
      use ${config.xdg.cacheHome}/starship/init.nu
    '';
  };
}

# {
#   enable = true;
#   settings = {
#     format = "$character $directory$git_branch$git_commit$git_status$rust$nodejs$deno";
#     right_format = "$cmd_duration";
#     continuation_prompt = "[∙](bright-white) ";
#     add_newline = true;
#     line_break = {
#       disabled = true;
#     };
#     scan_timeout = 10;
#     cmd_duration = {
#       min_time = 5000;
#       format = "[\\(](bold)⏱  [$duration](bold yellow)[\\)](bold) ";
#       show_milliseconds = false;
#     };
#     character = {
#       format = "$symbol";
#       # ▶ ᗌ ᗎ
#       success_symbol = "[ᗎ](bold green)";
#       error_symbol = "[ᗎ](bold red)";
#     };
#     directory = {
#       format = "[\\[](bold)[$path](bold 226)[$read_only](bold)[\\]](bold) ";
#       truncation_length = 2;
#       truncate_to_repo = false;
#     };
#     git_branch = {
#       symbol = "";
#       # format = "[\\(](bold)[$branch](bold 206) [:](bold) ";
#       format = "[\\($symbol](bold)[$branch](bold 206) ";
#       truncation_length = 15;
#       truncation_symbol = "…";
#       always_show_remote = true;
#     };
#     git_status = {
#       # format = '([$all_status](bold red)\) )';
#       format = "[:](bold) ([$all_status](bold red))[\\)](bold) ";
#       ahead = "⇡\${count}";
#       diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
#       behind = "⇣\${count}";
#     };
#     git_commit = {
#       commit_hash_length = 7;
#       format = "[⤠](bold) [$hash$tag](bold yellow underline) ";
#       tag_disabled = false;
#       tag_symbol = "🔖 ";
#     };
#     git_metrics = {
#       disabled = false;
#       only_nonzero_diffs = true;
#       added_style = "bold green";
#       deleted_style = "bold red";
#       format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
#       # format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
#     };
#     rust = {
#       format = "\\([$symbol$version](bold 208)\\) ";
#     };
#     nodejs = {
#       symbol = "⬢";
#       format = "[\\(](bold)[$symbol ($version )](bold 063)[\\)](bold) ";
#     };
#   };
# }
