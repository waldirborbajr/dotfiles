# https://nix-community.github.io/home-manager/options.html#opt-programs.gh.settings

{pkgs, ...}: {
  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      git_protocol = "ssh";
      prompt = "enabled";
      pager = "delta";
      aliases = {
        inbox = "api notifications --template '{{range .}}{{tablerow .subject.title .subject.url}}{{end}}'";
      };
    };
  };

}

