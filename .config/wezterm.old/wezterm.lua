--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local b = require("utils/background")
local cs = require("utils/color_scheme")
local f = require("utils/font")
local h = require("utils/helpers")
local k = require("utils/keys")
local w = require("utils/wallpaper")

local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	-- background
	background = {
		w.get_wallpaper(),
		b.get_background(),
	},

	-- font
	font = f.get_font(),
	font_size = 10.5,

	-- colors
	color_scheme = cs.get_color_scheme(),

	-- padding
	window_padding = {
		left = 30,
		right = 30,
		top = 20,
		bottom = 10,
	},

	set_environment_variables = {
		-- THEME_FLAVOUR = "latte",
		BAT_THEME = h.is_dark() and "Catppuccin-mocha" or "Catppuccin-latte",
	},

	-- general options
	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",

	-- keys
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- Send C-a when pressing C-a twice
  	{ key = "a", mods = "LEADER",       action = act.SendKey { key = "a", mods = "CTRL" } },
  	{ key = "c", mods = "LEADER",       action = act.ActivateCopyMode },
		
		k.cmd_key(".", k.multiple_actions(":ZenMode")),
		k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		k.cmd_key("f", k.multiple_actions(":Grep")),
		k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
		k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		k.cmd_key("P", k.multiple_actions(":GoToCommand")),
		k.cmd_key("p", k.multiple_actions(":GoToFile")),
		k.cmd_key("q", k.multiple_actions(":qa!")),
		-- k.cmd_to_tmux_prefix("1", "1"),
		-- k.cmd_to_tmux_prefix("2", "2"),
		-- k.cmd_to_tmux_prefix("3", "3"),
		-- k.cmd_to_tmux_prefix("4", "4"),
		-- k.cmd_to_tmux_prefix("5", "5"),
		-- k.cmd_to_tmux_prefix("6", "6"),
		-- k.cmd_to_tmux_prefix("7", "7"),
		-- k.cmd_to_tmux_prefix("8", "8"),
		-- k.cmd_to_tmux_prefix("9", "9"),
		-- k.cmd_to_tmux_prefix("`", "n"),
		-- k.cmd_to_tmux_prefix("b", "B"),
		-- k.cmd_to_tmux_prefix("C", "C"),
		-- k.cmd_to_tmux_prefix("d", "D"),
		-- k.cmd_to_tmux_prefix("G", "G"),
		-- k.cmd_to_tmux_prefix("g", "g"),
		-- k.cmd_to_tmux_prefix("j", "O"),
		-- k.cmd_to_tmux_prefix("k", "T"),
		-- k.cmd_to_tmux_prefix("l", "L"),
		-- k.cmd_to_tmux_prefix("n", '"'),
		-- k.cmd_to_tmux_prefix("N", "%"),
		-- k.cmd_to_tmux_prefix("o", "u"),
		-- k.cmd_to_tmux_prefix("T", "!"),
		-- k.cmd_to_tmux_prefix("t", "c"),
		-- k.cmd_to_tmux_prefix("w", "x"),
		-- k.cmd_to_tmux_prefix("z", "z"),

		k.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":source %"),
			})
		),

		k.cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":w"),
			})
		),

		{
			mods = "CMD|SHIFT",
			key = "}",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "{",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "p" }),
			}),
		},

		{
			mods = "CTRL",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{
			mods = "CTRL|SHIFT",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{ mods = "CTRL|SHIFT", key = "-", action = "DecreaseFontSize" }, -- Ctrl-Shift-- (key with -)
		{ mods = "CTRL|SHIFT", key = "+", action = "IncreaseFontSize" }, -- Ctrl-Shift-+ (key with =)
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.DisableDefaultAssignment,
		},
		{
			key = "z",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SpawnCommandInNewTab({
				args = { "zsh", "-l", "-c", "zellij attach || zellij" },
			}),
			-- action = wezterm.action.ShowLauncher
		},
		{
			key = "m",
			mods = "CTRL",
			action = wezterm.action.SpawnCommandInNewTab({
				args = { "ssh", "-t", "-p5556", "root@localhost", "zellij attach || zellij" },
			}),
			-- action = wezterm.action.ShowLauncher
		},
		{ key = "F2", mods = "", action = wezterm.action.ShowLauncher },

		-- FIX: disable binding
		-- {
		-- 	mods = "CMD",
		-- 	key = "`",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },

		{
			mods = "CMD",
			key = "~",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "b" }),
				act.SendKey({ key = "p" }),
			}),
		},

		{ 
			key = "V", 
			mods = "CTRL|SHIFT",
			action = act.SplitVertical { 
				domain = "CurrentPaneDomain" 
			} 
		},
  	-- SHIFT is for when caps lock is on
  	{ key = "H", 
			mods = "CTRL|SHIFT", 
			action = act.SplitHorizontal { 
				domain = "CurrentPaneDomain" 
			} 
		},

	  { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
	  { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
	  { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
	  { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
	  { key = "x", mods = "LEADER",       action = act.CloseCurrentPane { confirm = true } },
	  { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },
	  { key = "s", mods = "LEADER",       action = act.RotatePanes "Clockwise" },
	  -- We can make separate keybindings for resizing panes
	  -- But Wezterm offers custom "mode" in the name of "KeyTable"
	  { key = "r", mods = "LEADER",       action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

	  -- Tab keybindings
	  { key = "n", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
	  { key = "[", mods = "LEADER",       action = act.ActivateTabRelative(-1) },
	  { key = "]", mods = "LEADER",       action = act.ActivateTabRelative(1) },
	  { key = "t", mods = "LEADER",       action = act.ShowTabNavigator },
	  -- Key table for moving tabs around
	  { key = "m", mods = "LEADER",       action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },

	  -- Lastly, workspace
	  { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
	},

	launch_menu = {
		{
			label = "M2-wired",
			args = { "ssh", "-b", "10.0.0.1", "-t", "martins3@10.0.0.2", "zellij attach || zellij" },
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
	},
}

return config
