# NVIM For Voidfiles
Built using vim.pack and lots of mini plugins

## Installation
### Try with no install

Run the following command:
```bash
nix run git+https://git.voidarc.co.uk/voidarc/nvim#remote
```
This will use NVIM_APPNAME="nvim-remote", and pull config from the git repo without you having to install it to your system.
You will have to wait for the initial plugin install, so I advise just pressing "always" when prompted. Due to autocommands,
when the plugins have installed you will have to restart nvim with the same run command to enter the editor properly.

### Install into nix config without adding config

You can add the repo to your flake like this:
```nix
{
    inputs = {
        nvim-voidarc.url = "git+https://git.voidarc.co.uk/voidarc/nvim"
    }
}
```
And then add this to your package list:
```nix
inputs.nvim-voidarc.packages.${stdenv.hostPlatform.system}.remote
```
I don't recommend making it follow the system nixpkgs as treesitter needs unstable in order to work properly.

### Install into nix config and add local config

Clone this repo into your nvim config directory (make sure to back up beforehand):
```
git clone https://git.voidarc.co.uk/voidarc/nvim ~/.config/nvim
```
Then add that folder as an input to your flake:
```nix
{
    inputs = {
        nvim-voidarc.url = "git+file:///home/username/.config/nvim";
    }
}
```
Adjust the path and the username to what they are on your system. The input should be the path of the directory
that contains the flake, in this case the flake's path would be `/home/username/.config/nvim/flake.nix`.

Then add the default package to your system package:
```nix
inputs.nvim-voidarc.packages.${stdenv.hostPlatform.system}.default
```
Adding the remote package here will still work, but defeats the point of cloning it locally.

## Usage

This is a very esoteric config. I am quite opinionated, so there isn't any nice stuff like a homepage or which-keys.
Instead, there is efficiency. This is the minimum amount of pacakges required in order to support full functionality,
while also being highly extensible and adaptable to any programming language that I could want to program in.

### Keybinds

All keybinds can be found in the `lua/config/binds.lua` file, with a few exceptions. The `Keybind` function is a shorthand for the vim api.
All default vim bindings remain untouched, with almost all of the set binds having a leader prefix.

The leader key is space, configurable at the top of the `init.lua` file. When referring to the leader key, assume I mean space.

#### Navigation

- \<leader\>ff - Open Telescope fuzzy finder
- \<leader\>fn - Open Telescope file manager
- \<leader\>fg - Telescope live grep (only works in git repos afaik)
- \<leader\>fb - Telescope list of open buffers
- \<leader\>bd - Delete focused buffer

If a file is open, Telescope is configured to jump to the pane/tab where that file is open, rather than open it in the current pane.
This allows for a more consistent editing experience, such as having seperate tabs for backend and frontend files.

- \<C-t\>l - Next tab
- \<C-t\>h - Previous tab
- \<C-t\>j - New tab to the right
- \<C-t\>q - Close tab (Keeps buffers open)

Instead of using \<C-t\>j, I prefer to find the file in Telescope and use <C-t>, which opens the file in a new tab. This ovverides the
regular Telescope behaviour of jumping to the relevant pane, which only applies to enter. Similarly, <C-v> in Telescope opens the
selected file in a split to the right in the current tab. All <C-w> binds for navigating windows remain unchanged

#### Editing

- \<leader\>d - Open vim.lsp.diagnostic float menu
- gd - Go to definition of function
- ss - Open flash.nvim menu

Flash nvim has no leader key for ease of access. Non-text based flash functions are available according to the binds, but I don't use them.

#### Session management

- \<leader\>qj - Save session and exit
- \<leader\>qd - Delete session and exit

Both of these commands run `wqa`, meaning that even when deleting a session no data is ever lost (not that autosave isn't on by default lol).
When opening nvim in a folder with a `.session` file, the session will automatically be restored, including window layout. For more info, see
the mini.sessions documentation. Sessions autosave, but it is faster to use the save keybind than quit all windows one by one or run `:wqa`
