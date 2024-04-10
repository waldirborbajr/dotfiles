## My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```sh
sudo nala install git
```

### Stow

```sh
sudo nala install stow
```

## How to install

1. Install [GNU Stow](https://www.gnu.org/software/stow/) (`sudo nala install stow`) or use my [GLink](https://github.com/waldirborbajr/glink) (`go install github.com/waldirborbajr/glink@latest`)

3. Clone this repository

```sh
$ git clone git@github.com/waldirborbajr/dotfiles.git
$ cd dotfiles
```

3. Run stow command

```sh
$ stow . -t ~
```

## Software

- Terminal:
  - [Wezterm](https://wezfurlong.org/wezterm)
  - [Alacritty](https://alacritty.org/)
- Font: [Monaspace](https://monaspace.githubnext.com/)
- Colors: [catppuccin](https://github.com/catppuccin/catppuccin)
- Shell: [zsh](https://www.zsh.org/)  and [Oh My Zsh](https://ohmyz.sh/)
- Multiplexer:
  - [tmux](https://github.com/tmux/tmux/wiki)
  - [zellij](https://zellij.dev/)
- Editor: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- Nala package manager: [nala]((https://github.com/volitank/nala)

