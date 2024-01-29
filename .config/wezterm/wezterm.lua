--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require("wezterm")
local platform = require("utils.platform")()
local act = wezterm.action

local config = {}

local mod = {}

if platform.is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win or platform.is_linux then
	mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
	mod.SUPER_REV = "ALT|CTRL"
end

-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.default_prog = { "/usr/bin/env", "zsh" }

config.color_scheme = "Catppuccin Frappe"

config.font = wezterm.font("FiraCode Nerd Font", { weight = "Medium", stretch = "Normal", style = "Normal" })
config.font_size = 10.5

config.hide_mouse_cursor_when_typing = true

config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = "0cell",
}

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- misc/useful --
	{ key = "F1", mods = "NONE", action = "ActivateCopyMode" },
	{ key = "F2", mods = "NONE", action = act.ActivateCommandPalette },
	{ key = "F3", mods = "NONE", action = act.ShowLauncher },
	{ key = "F4", mods = "NONE", action = act.ShowTabNavigator },
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	{ key = "F12", mods = "NONE", action = act.ShowDebugOverlay },
	-- { key = 'f', mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },

	-- copy/paste --
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	-- tabs --
	-- tabs: spawn+close
	{ key = "t", mods = mod.SUPER, action = act.SpawnTab("DefaultDomain") },
	-- { key = 't', mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'WSL:Ubuntu' }) },
	{ key = "w", mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

	-- tabs: navigation
	{ key = "[", mods = mod.SUPER, action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = mod.SUPER, action = act.ActivateTabRelative(1) },
	{ key = "[", mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
	{ key = "]", mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

	-- panes: zoom+close pane
	{ key = "z", mods = mod.SUPER_REV, action = act.TogglePaneZoomState },
	{ key = "w", mods = mod.SUPER, action = act.CloseCurrentPane({ confirm = false }) },

	-- panes: navigation
	{ key = "k", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Down") },
	{ key = "h", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Right") },

	-- panes: resize
	{ key = "UpArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "LeftArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Right", 1 }) },

	-- fonts --
	-- fonts: resize
	{ key = "UpArrow", mods = mod.SUPER, action = act.IncreaseFontSize },
	{ key = "DownArrow", mods = mod.SUPER, action = act.DecreaseFontSize },
	{ key = "r", mods = mod.SUPER, action = act.ResetFontSize },

	-- window --
	-- spawn windows
	{ key = "n", mods = mod.SUPER, action = act.SpawnWindow },

	-- panes --
	-- panes: split panes
	{
		key = [[/]],
		mods = mod.SUPER_REV,
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = [[\]],
		mods = mod.SUPER_REV,
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = [[-]],
		mods = mod.SUPER_REV,
		action = act.CloseCurrentPane({ confirm = true }),
	},

	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	-- Lastly, workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	{ key = "M", mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },

	-- https://wezfurlong.org/wezterm/config/lua/keyassignment/QuickSelectArgs.html
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
				-- doesn't work (open_with doesn't detect as should be opened in
				-- browser or something else?)
				-- 'www\\.\\S+',
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

config.launch_menu = {
	{
		label = "Pi4-wired",
		args = { "ssh", "borba@192.168.1.19" },
	},
	{
		label = "Mi-wired",
		args = { "ssh", "-b", "10.0.0.1", "-t", "martins3@10.0.0.2", "zellij attach || zellij" },
	},
	{
		label = "M2",
		args = { "ssh", "-t", "martins3@192.168.11.99", "zellij attach || zellij" },
	},
	{
		label = "Mi",
		args = { "ssh", "-t", "martins3@192.168.11.17", "zellij attach || zellij" },
	},
	{
		label = "zellij",
		args = { "/bin/sh", "-l", "-c", "zellij attach || zellij" },
	},
	{
		label = "QEMU",
		args = { "ssh", "-t", "-p5556", "root@localhost", "zellij attach || zellij" },
	},
	{
		label = "bare",
		args = { "zsh" },
	},
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

return config
