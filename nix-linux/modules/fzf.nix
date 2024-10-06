{ ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;

    defaultCommand = "fd -t f";
  };
}
