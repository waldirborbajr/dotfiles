-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- Config builder
local config = wezterm.config_builder()
local modkey = "ALT"

-- ======= APPEARANCE =======
config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "RESIZE" -- remove window decorations
config.hide_tab_bar_if_only_one_tab = true
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false

config.font = wezterm.font_with_fallback({
	"JetBrains Mono Nerd Font",
})
config.font_size = 11.0
config.default_cwd = wezterm.home_dir
config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}
config.animation_fps = 60
config.max_fps = 120

config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.harfbuzz_features = { "calt=0" }

config.window_padding = {
	left = 5,
	right = 0,
	top = 5,
	bottom = 0,
}

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.default_cursor_style = "SteadyBar"

-- ======= KEYBINDINGS =======
config.keys = {
	-- Spawn new window
	{
		key = "n",
		mods = "CMD", -- 'CMD' on macOS, 'CTRL|SHIFT' on Linux
		action = act.SpawnCommandInNewWindow({
			cwd = wezterm.home_dir,
		}),
	},

	-- Spawn a new tab
	{ key = "t", mods = modkey, action = act.SpawnTab("CurrentPaneDomain") },

	-- Close current tab without prompt
	{ key = "w", mods = modkey, action = act.CloseCurrentTab({ confirm = false }) },

	-- Splitting panes (Neovim-style)
	{ key = "\\", mods = modkey, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = modkey, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Navigate between panes with [Alt]+[H/J/K/L]
	{ key = "h", mods = modkey, action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = modkey, action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = modkey, action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = modkey, action = act.ActivatePaneDirection("Right") },

	-- Resize panes with [Alt+Shift]+[H/J/K/L]
	{ key = "H", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "J", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "K", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "L", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },

	-- Clipboard
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	-- ===== Tabs (tmux-style) =====
	-- Move between tabs
	{ key = "[", mods = "ALT|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "ALT|SHIFT", action = act.ActivateTabRelative(1) },

	-- Reorder tabs
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },
}

-- Dynamically generate [Alt]+[1..9] tab switching
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = modkey,
		action = act.ActivateTab(i - 1),
	})
end
table.insert(config.keys, {
	key = "0",
	mods = modkey,
	action = act.ActivateTab(9),
})

-- ======= MOUSE BINDINGS =======
config.mouse_bindings = {
	-- Open links with mouse click
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- ======= STATUS BAR =======
wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#89b4fa" } },
		{ Text = " " .. date .. " " },
	}))
end)

-- ======= TAB TITLE CUSTOMIZATION =======
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane

	-- Get CWD
	local cwd_uri = pane.current_working_dir
	local cwd = cwd_uri and (cwd_uri.file_path or cwd_uri.path) or ""
	if cwd ~= "" then
		cwd = cwd:gsub("^.*[/\\]([^/\\]+)[/\\]?$", "%1")
	end

	-- Get process name
	local process = pane.foreground_process_name or ""

	-- Format title: "directory - process"
	return cwd .. " - " .. process
end)

-- ======= RETURN CONFIG =======
return config
