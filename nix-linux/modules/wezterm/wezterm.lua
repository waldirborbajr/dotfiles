local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.enable_tab_bar = false -- remove tab bar

config.window_decorations = "RESIZE" -- remove window decorations
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.color_scheme = "Catppuccin Frappe"

config.audible_bell = "Disabled" -- disable sounds when at the end of doc

-- this is going to be used to toggle between color schemes
-- local function scheme_for_apperance(appearance)
-- 	if appearance:find("Dark") then
-- 		return "Catppuccin Frappe"
-- 	else
-- 		return "Catppuccin Latte"
-- 	end
-- end
--
-- print(wezterm.gui.get_appearance())

-- config.color_scheme = scheme_for_apperance(wezterm.gui.get_apperanace()) -- get the current theme

config.font = wezterm.font("MesloLGS Nerd Font", { weight = "Medium", stretch = "Normal", style = "Normal" })
config.font_size = 12
-- config.font_weight
config.cursor_blink_rate = 800

config.enable_tab_bar = false

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- config.window_background_image = "~/Documents/img-backgrounds/sacred-geometry.jpeg"
--
-- config.window_background_gradient = {
--   orientation = 'Vertical',
--   colors = {
--     '#1E1E2F',
--     '#1E1E2F',
--   },
--   blend = 'Rgb',
--   interpolation = 'Linear',
-- }

config.window_padding = {
	left = 2.5,
	right = 2.5,
	top = 2.5,
	bottom = 4.5,
}
-- config.window_padding = {
--   left = 55,
--   right = 44,
--   top = 44,
--   bottom = 22,
-- }

-- config.default_prog = { 'zel', '-l', 'welcome'}

config.keys = {
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	},
	{
		-- Disable Cmd+T (or Super+T on some systems)
		key = "t",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
