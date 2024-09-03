# https://nix-community.github.io/home-manager/options.html#opt-programs.git.enable

{ config, pkgs, ... }:

# {
#   programs.git = {
#     enable = true;
#
#     userName = "Waldir Borba Junior";
#     userEmail = "wborbajr@gmail.com";
#
#     # signing.signByDefault = true;
#     # signing.key = null;
#
#     delta = {
#       enable = true;
#
#       options = {
#         features = "side-by-side line-numbers decorations";
#         line-numbers = "relative";
#         navigate = "true";
#         decorations = "commit-decoration file-style";
#         commit-decoration-style = "blue box ul";
#         file-style = "blue ul";
#       };
#     };
#
#     extraConfig = {
#
#       init.defaultBranch = "main";
#
#       merge = {
#         conflictstyle  = "diff3";
#       };
#
#       diff = {
#         colorMoved = "default";
#       };
#
#       push = {
#         default = "simple";
#       };
#
#       color = {
#         ui = "auto";
#       };
#
#       submodule = {
#         recurse = "true";
#       };
#     };
#
#     aliases = {
#       a = "add";
#       c = "commit";
#       p = "push";
#       d = "diff";
#       graph = "log --graph --color --pretty=format:'%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n'";
#       one = "log --oneline --all";
#       stat = "status -sb";
#       last = "show -1";
#       unstage = "reset HEAD --";
#       cached = "diff --cached";
#       ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
#     };
#   };
#
#   programs.gh = {
#     enable = true;
#
#     settings.git_protocol = "ssh";
#   };
# }

{
programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Waldir Borba Junior";
    userEmail = "wborbajr@gmail.com";
    # signing = {
    #   key = "5C841D3CFDFEC4E0";
    #   signByDefault = false;
    # };
    aliases = {
      a = "add";
      c = "commit";
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      cl = "clone";
      cm = "commit -m";
      co = "checkout";
      cp = "cherry-pick";
      cpx = "cherry-pick -x";
      d = "diff";
      f = "fetch";
      fo = "fetch origin";
      fu = "fetch upstream";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      pl = "pull";
      pr = "pull -r";
      ps = "push";
      psf = "push -f";
      rb = "rebase";
      rbi = "rebase -i";
      r = "remote";
      ra = "remote add";
      rr = "remote rm";
      rv = "remote -v";
      rs = "remote show";
      st = "status";
    };
    extraConfig = {
      init.defaultBranch = "main";
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      pull = {
        rebase=true;
      };
      mergetool.prompt = "false";
      git.path = toString pkgs.git;
    };
    # includes = [
    #   # use different signing key
    #   {
    #     condition = "gitdir:~/work/";
    #     contents = {
    #       user = {
    #         name = "Jonathan Ringer";
    #         email = "jringer@anduril.com";
    #         signingKey = "7B8CFA0F33328D9A";
    #       };
    #     };
    #   }
    #   # prevent background gc thread from constantly blocking reviews
    #   {
    #     condition = "gitdir:~/projects/nixpkgs";
    #     contents = {
    #       gc.auto = 0;
    #       fetch.prune = false;
    #     };
    #   }
    #
    # ];
  };

}
