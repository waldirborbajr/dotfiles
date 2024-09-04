# # https://nix-community.github.io/home-manager/options.html#opt-programs.git.enable

# { config, pkgs, ... }:

# {
# programs.git = {
#     enable = true;
#     lfs.enable = true;
#     userName = "Waldir Borba Junior";
#     userEmail = "wborbajr@gmail.com";
#     difftastic.enable = true;
#     # signing = {
#     #   key = "5C841D3CFDFEC4E0";
#     #   signByDefault = true;
#     # };
#     aliases = {
#       a = "add";
#       c = "commit";
#       ca = "commit --amend";
#       can = "commit --amend --no-edit";
#       cl = "clone";
#       cm = "commit -m";
#       co = "checkout";
#       cp = "cherry-pick";
#       cpx = "cherry-pick -x";
#       d = "diff";
#       f = "fetch";
#       fo = "fetch origin";
#       fu = "fetch upstream";
#       lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
#       lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
#       pl = "pull";
#       pr = "pull -r";
#       ps = "push";
#       psf = "push -f";
#       rb = "rebase";
#       rbi = "rebase -i";
#       r = "remote";
#       ra = "remote add";
#       rr = "remote rm";
#       rv = "remote -v";
#       rs = "remote show";
#       st = "status";
#     };
#     extraConfig = {
#       init.defaultBranch = "main";
#       merge = {
#         tool = "vimdiff";
#         conflictstyle = "diff3";
#       };
#       pull = {
#         rebase=true;
#       };
#       mergetool.prompt = "false";
#       git.path = toString pkgs.git;
#     };
#   };
# }


{pkgs, ...}: {
  home.packages = with pkgs; [
    act
    gist
    gitflow
    zsh-forgit
  ];

  programs = {
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      lfs.enable = true;
      delta.enable = true;

      userName = "Waldir Borba Junior";
      userEmail = "wborbajr@gmail.com";
      # signing = {
      #   key = "A69A110979DF4E36";
      #   signByDefault = true;
      # };

      aliases = {
        a = "add";
        af = "!git add $(git ls-files -m -o --exclude-standard | sk -m)";
        b = "branch";
        br = "branch";
        c = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        co = "checkout";
        d = "diff";
        ds = "diff --staged";
        edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
        essa = "push --force";
        fuck = "commit --amend -m";
        graph = "log --all --decorate --graph --oneline";
        hist = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all";
        l = "log";
        llog = "log --graph --name-status --pretty=format:\"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset\" --date=relative";
        oops = "checkout --";
        p = "push";
        pf = "push --force-with-lease";
        pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        r = "rebase";
        s = "status --short";
        ss = "status";
        st = "status";
      };

      extraConfig = {
        init.defaultBranch = "main";
        branch.autosetupmerge = "true";
        push.default = "current";
        merge.stat = "true";
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        repack.usedeltabaseoffset = "true";
        pull.ff = "only";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };

      ignores = [
        "*~"
        "*.swp"
        "*result*"
        ".direnv"
        "node_modules"
      ];
    };
  };
}
