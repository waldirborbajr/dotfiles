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
      #   gpgPath = "${pkgs.gnupg}/bin/gpg";
      #   key = "FD9F89445E5EACD7";
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
        sha = "rev-parse origin/main";
      };

      extraConfig = {
        user = {
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPZIDW3PxYoeJem2ZKV0vbUJj2GEAX+pdL+VenmYRwT PopOS";
        };
        init.defaultBranch = "main";
        branch.autosetupmerge = "true";
        # push.default = "current";
        merge.stat = "true";
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        repack.usedeltabaseoffset = "true";
        pull = {
          ff = "only";
          rebase=true;
        };
        push = {
          autoSetupRemote = true;
          default = "simple";
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        git.path = toString pkgs.git;
      };

      # core = {
      #   compression = -1;
      #   autocrlf = "input";
      #   whitespace = "trailing-space,space-before-tab";
      #   precomposeunicode = true;
      # };

      attributes = [
        "*.c     diff=cpp"
        "*.h     diff=cpp"
        "*.c++   diff=cpp"
        "*.h++   diff=cpp"
        "*.cpp   diff=cpp"
        "*.hpp   diff=cpp"
        "*.cc    diff=cpp"
        "*.hh    diff=cpp"
        "*.m     diff=objc"
        "*.mm    diff=objc"
        "*.cs    diff=csharp"
        "*.css   diff=css"
        "*.html  diff=html"
        "*.xhtml diff=html"
        "*.ex    diff=elixir"
        "*.exs   diff=elixir"
        "*.go    diff=golang"
        "*.php   diff=php"
        "*.pl    diff=perl"
        "*.py    diff=python"
        "*.md    diff=markdown"
        "*.rb    diff=ruby"
        "*.rake  diff=ruby"
        "*.rs    diff=rust"
        "*.lisp  diff=lisp"
        "*.el    diff=lisp"
      ];

      ignores = [
        ".vscode"
        # direnv stuff
        ".direnv"
        ".env"
        # Ignore coc.vim local vim dir
        ".vim"
        # In any project, we want to ignore the "scratch" subdirectories
        "scratch"
        # Ignore Session.vim files created by obsession.vim
        "Session.vim"
        # Ignore tags files
        "tags"
        "tags.lock"
        "tags*temp"
        "tags*.tmp"
        "tmp"
        # Created by https://www.gitignore.io/api/linux,macos,windows
        # Edit at https://www.gitignore.io/?templates=linux,macos,windows
        ### Linux ###
        "*~"
        # temporary files which can be created if a process still has a handle open of a deleted file
        ".fuse_hidden*"
        # KDE directory preferences
        ".directory"
        # Linux trash folder which might appear on any partition or disk
        ".Trash-*"
        # .nfs files are created when an open file is removed but is still being accessed
        ".nfs*"
        ### macOS ###
        # General
        ".DS_Store"
        ".AppleDouble"
        ".LSOverride"
        # Icon must end with two \r
        "Icon"
        # Thumbnails
        "._*"
        # Files that might appear in the root of a volume
        ".DocumentRevisions-V100"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".VolumeIcon.icns"
        ".com.apple.timemachine.donotpresent"
        # Directories potentially created on remote AFP share
        ".AppleDB"
        ".AppleDesktop"
        "Network Trash Folder"
        "Temporary Items"
        ".apdisk"
        ### Windows ###
        # Windows thumbnail cache files
        "Thumbs.db"
        "Thumbs.db:encryptable"
        "ehthumbs.db"
        "ehthumbs_vista.db"
        # Dump file
        "*.stackdump"
        # Folder config file
        "[Dd]esktop.ini"
        # Recycle Bin used on file shares
        "$RECYCLE.BIN/"
        # Windows Installer files
        "*.cab"
        "*.msi"
        "*.msix"
        "*.msm"
        "*.msp"
        # Windows shortcuts
        "*.lnk"
        # End of https://www.gitignore.io/api/linux,macos,windows
        "Session.vim*"
        "*~"
        "*.swp"
        "*result*"
        ".direnv"
        "node_modules"
        ".idea"
        ".svn"
        ".env"
        ".envrc"
        "*.log"
      ];
    };
  };
}
