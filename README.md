# Nix config

I manage my systems with [nix](https://nixos.org):

* [home-manager](https://github.com/nix-community/home-manager)

I do not expect anyone else to use this system, but there may be useful information in the configs.

## Layout

* home-manager configuration under [`home`](./home) with "top level" configuration at [`home/home.nix`](./home/home.nix) with imports to other sub-modules. I am trying to migrate to a more modular configuration as part of learning nix, but I'm not 100% there yet

## Software

- Terminal:
  - [Wezterm](https://wezfurlong.org/wezterm)
  - [Alacritty](https://alacritty.org/)
- Font: [Meslo](https://www.nerdfonts.com/)
- Colors: [catppuccin](https://github.com/catppuccin/catppuccin)
- Shell: [zsh](https://www.zsh.org/)  and [ZimFM](https://zimfw.sh/)
- Multiplexer:
  - [tmux](https://github.com/tmux/tmux/wiki)
  - [zellij](https://zellij.dev/)
- Editor: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- Nala package manager: [nala]((https://github.com/volitank/nala)

## Hardware

Need a new one, ASAP. I'm currently on an old, but very old i5 1st Gen. Praying for an upgrade. 
