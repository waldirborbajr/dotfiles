# https://nix-community.github.io/home-manager/options.html#opt-programs.gh.settings

{pkgs, ...}: {
  programs.gh = {
    enable = true;
     extensions = [
      pkgs.gh-dash
    ];
    settings = {
      # version = "1";
      git_protocol = "ssh";
      prompt = "enabled";
      pager = "delta";
      aliases = {
        inbox = "api notifications --template '{{range .}}{{tablerow .subject.title .subject.url}}{{end}}'";
        co = "pr checkout";
        pl = "pr list";
        ga = "dash";
        clone = "repo clone";
        v = "repo view --web";
        pv = "pr view --web";
        pr = "pr create --web";
      };
    };
  };

}

