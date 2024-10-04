-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Catppuccin Frappe'
config.window_decorations = 'RESIZE' -- remove window decorations
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false

config.window_padding = {
  left = 4.5,
  right = 2.5,
  top = 4.5,
  bottom = 2.5,
}

config.default_cursor_style = 'SteadyBar'

config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 12

config.enable_tab_bar = false

config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm
return config
