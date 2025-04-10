{ ... }: {
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--preview 'bat -p -f {}'"
      "--height 50%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    # defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
    # Ctrl+T: find and insert path
    # Alt+C: find and chdir
    # Ctrl+R: search history
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
}
