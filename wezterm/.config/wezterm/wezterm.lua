local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.color_scheme = "Catppuccin Macchiato"

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},

	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "l",
		mods = "CTRL",
		action = wezterm.action.SendString("clear\n"),
	},
}

config.ssh_domains = {
	{
		name = "rpi",
		remote_address = "192.168.1.110",
		username = "raspi",
		ssh_option = {
			identityfile = "~/.ssh/id_ed25519",
		},
	},
}

return config
