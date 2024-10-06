{ config, ... }: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableTransience = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      cmd_duration = {
        min_time = 1000;
        format = "[$duration]($style) ";
      };
      git_branch = {
        symbol = " ";
        format = "on [$symbol$branch]($style) ";
        # truncation_length = 4;
        # truncation_symbol = "…/";
      };
      git_status.format = "[$ahead_behind$untracked$modified]($style) ";
      directory = {
        read_only = " ";
        truncate_to_repo = true;
        truncation_length = 4;
        truncation_symbol = "";
      };
      username.format = "[$user]($style)";
      hostname = {
        ssh_symbol = "@";
        format = "$ssh_symbol[$hostname](bright-blue) ";
      };
      golang.symbol = "";
      rust.symbol = "rs ";
      lua.symbol = "󰢱 ";
      nix_shell.symbol = " ";

      aws.disabled = true;
      azure.disabled = true;
      buf.disabled = true;
      bun.disabled = true;
      c.disabled = true;
      cmake.disabled = true;
      conda.disabled = true;
      container.disabled = true;
      crystal.disabled = true;
      daml.disabled = true;
      dart.disabled = true;
      deno.disabled = true;
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      env_var.disabled = true;
      erlang.disabled = true;
      fennel.disabled = true;
      gcloud.disabled = true;
      golang.disabled = false;
      gradle.disabled = true;
      guix_shell.disabled = true;
      haskell.disabled = true;
      haxe.disabled = true;
      helm.disabled = true;
      java.disabled = true;
      jobs.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      kubernetes.disabled = true;
      lua.disabled = true;
      nim.disabled = true;
      nix_shell.disabled = false;
      nodejs.disabled = true;
      ocaml.disabled = true;
      openstack.disabled = true;
      package.disabled = true;
      perl.disabled = true;
      php.disabled = true;
      purescript.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      rust.disabled = false;
      scala.disabled = true;
      shlvl.disabled = true;
      singularity.disabled = true;
      swift.disabled = true;
      terraform.disabled = true;
      vagrant.disabled = true;
      zig.disabled = true;
    };
  };
}

