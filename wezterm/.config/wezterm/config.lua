local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Cursor
config.default_cursor_style = "SteadyBar"
-- Cursor follows Nord theme fg/bg instead of defaulting to white
config.force_reverse_video_cursor = true

-- Behavior
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false
config.scrollback_lines = 10000

-- Window
config.window_decorations = "RESIZE"
config.window_padding = { left = 3, right = 3, top = 0, bottom = 0 }

-- Tab bar (disabled — using workspaces instead)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false

-- Font
config.font_size = 14
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })

-- Visual: dim inactive panes so focused pane is always clear
config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.65,
}

-- Background: nord base color (#2e3440) at 95% opacity
config.background = {
	{
		source = { Color = "#2e3440" },
		width = "100%",
		height = "100%",
		opacity = 0.95,
	},
}

-- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
