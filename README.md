# dotfiles
This is my dotfile playground for learning nix as my reproducable setup for handling dotfiles on a macOS system

this repository will be updated & improved upon as I learn the nix language and ways of working

## Installation
### nixOS:

Taken directly from nxiOS.org:
```shell
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
````
### Home manager
read more: https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone

```shell
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```

### flake support
add the following to ~/.config/nix/nix.config
```shell
experimental-features = nix-command flakes
```
## Software

- Terminal:
  - [Wezterm](https://wezfurlong.org/wezterm)
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

