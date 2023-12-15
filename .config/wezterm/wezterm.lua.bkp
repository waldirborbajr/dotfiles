local wezterm = require("wezterm")

local config = {
	term = "wezterm",
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 10.5,
	-- line_height = 1.6,
	underline_position = -7,
	window_padding = {
		left = "1.5cell",
		right = "1.5cell",
		top = "0.4cell",
		bottom = "0.4cell",
	},
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	enable_tab_bar = false,
	adjust_window_size_when_changing_font_size = false,
	keys = {
		{ key = "f", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
		{ key = "t", mods = "SUPER", action = wezterm.action.Nop },
		{ key = "\\", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
	},
	front_end = "WebGpu", -- Temp: This is new default in nightly, can remove later!
}

-- This doesn't work well on a dual screen setup, and is hopefully a temporary solution to the font rendering oddities
-- shown in https://github.com/wez/wezterm/issues/4096. Ideally I'll switch to using `dpi_by_screen` at some point,
-- but for now 11pt @ 109dpi seems to be the most stable for font rendering on my 38" ultrawide LG monitor here.
wezterm.on("window-config-reloaded", function(window)
	if wezterm.gui.screens().active.name == "LG HDR WQHD" then
		window:set_config_overrides({
			dpi = 109,
			font_size = 11,
		})
	end
end)

-- Important for screencasting...
wezterm.on("window-config-reloaded", function(window)
	if wezterm.gui.screens().active.name == "24GL600F" then
		local dpi = 92
		local font_size = 13

		-- For 1280x720 HiDPI specifically, which will have height of 1440
		if wezterm.gui.screens().active.height == 1440 then
			dpi = 144
			font_size = 15.5
		end

		window:set_config_overrides({
			dpi = dpi,
			font_size = font_size,
			line_height = 1.6,
			underline_position = -12,
			window_padding = {
				top = "0.7cell",
				bottom = "0.3cell",
			},
		})
	end
end)

return config

-- return {
-- 	-- color_scheme = 'termnial.sexy',
-- 	color_scheme = "Catppuccin Mocha",
-- 	enable_tab_bar = false,
-- 	-- FONT
-- 	font = wezterm.font("JetBrainsMono Nerd Font"),
-- 	font_size = 10.5,
-- 	--	macos_window_background_blur = 30,

-- 	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
-- 	-- window_background_image_hsb = {
-- 	-- 	brightness = 0.01,
-- 	-- 	hue = 1.0,
-- 	-- 	saturation = 0.5,
-- 	-- },
-- 	-- window_background_opacity = 0.92,
-- 	window_background_opacity = 1.0,
-- 	-- window_background_opacity = 0.78,
-- 	-- window_background_opacity = 0.20,
-- 	window_decorations = "RESIZE",
-- 	keys = {
-- 		{
-- 			key = "f",
-- 			mods = "CTRL",
-- 			action = wezterm.action.ToggleFullScreen,
-- 		},
-- 	},
-- 	mouse_bindings = {
-- 		-- Ctrl-click will open the link under the mouse cursor
-- 		{
-- 			event = { Up = { streak = 1, button = "Left" } },
-- 			mods = "CTRL",
-- 			action = wezterm.action.OpenLinkAtMouseCursor,
-- 		},
-- 	},
-- }
