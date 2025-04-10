-- Pull in the wezterm API
local wezterm = require("wezterm")

-- local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Open Maximized
-- wezterm.on('gui-startup', function()
--   local tab, pane, window = mux.spawn_window({})
--   window:gui_window():maximize()
-- end)

-- local cache_dir = os.getenv('HOME') .. '/.cache/wezterm/'
-- local window_size_cache_path = cache_dir .. 'window_size_cache.txt'
--
-- wezterm.on('gui-startup', function()
--   os.execute('mkdir ' .. cache_dir)
--
--   local window_size_cache_file = io.open(window_size_cache_path, 'r')
--   local window
--   if window_size_cache_file ~= nil then
--     _, _, width, height = string.find(window_size_cache_file:read(), '(%d+),(%d+)')
--     _, _, window = mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
--     window_size_cache_file:close()
--   else
--     _, _, window = mux.spawn_window({})
--     window:gui_window():maximize()
--   end
-- end)
--
-- wezterm.on('window-resized', function(_, pane)
--   local tab_size = pane:tab():get_size()
--   local cols = tab_size['cols']
--   local rows = tab_size['rows'] + 2 -- Without adding the 2 here, the window doesn't maximize
--   local contents = string.format('%d,%d', cols, rows)
--
--   local window_size_cache_file = io.open(window_size_cache_path, 'w')
--   -- Check if the file was successfully opened
--   if window_size_cache_file then
--     window_size_cache_file:write(contents)
--     window_size_cache_file:close()
--   else
--     print('Error: Could not open file for writing: ' .. window_size_cache_path)
--   end
-- end)

-- Open FullScreen without option to minimize
-- wezterm.on("gui-startup", function(window)
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	local gui_window = window:gui_window()
-- 	gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
-- end)

config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "RESIZE" -- remove window decorations
config.hide_tab_bar_if_only_one_tab = true
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false

config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.harfbuzz_features = { "calt=0" }
config.max_fps = 120

config.window_padding = {
	left = 5,
	right = 0,
	top = 5,
	bottom = 0,
}

config.default_cursor_style = "SteadyBar"

config.font = wezterm.font("MesloLGS Nerd Font")
-- config.font = wezterm.font("JetBrains Mono") -- MesloLGS Nerd Font")
config.font_size = 11

config.enable_tab_bar = false

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- debug_key_events=true,
config.keys = {
	-- Turn off the default CMD-m Hide action on macOS by making it
	-- send the empty string instead of hiding the window

	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },

	{ key = "{", mods = "CTRL|SHIFT", action = wezterm.action({ SplitVertical = {} }) },
	{ key = "}", mods = "CTRL|SHIFT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{
		key = "A",
		mods = "CTRL|SHIFT",
		action = wezterm.action.QuickSelect,
	},
	-- Quickly open config file with common macOS keybind
	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewWindow({
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			args = { os.getenv("SHELL"), "-c", "$VISUAL $WEZTERM_CONFIG_FILE" },
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
