-- Pull in the wezterm API
local wezterm = require('wezterm')

local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Open Maximized
wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- Open FullScreen without option to minimize
-- wezterm.on('gui-startup', function(window)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   local gui_window = window:gui_window()
--   gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
-- end)

config.color_scheme = 'Catppuccin Macchiato'
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

-- debug_key_events=true,
config.keys = {
  -- Turn off the default CMD-m Hide action on macOS by making it
  -- send the empty string instead of hiding the window

  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivatePaneDirection = 'Left' }) },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivatePaneDirection = 'Right' }) },
  { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivatePaneDirection = 'Down' }) },
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action({ ActivatePaneDirection = 'Up' }) },

  { key = '{', mods = 'CTRL|SHIFT', action = wezterm.action({ SplitVertical = {} }) },
  { key = '}', mods = 'CTRL|SHIFT', action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
  { key = 'Enter', mods = 'CTRL', action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
}

-- and finally, return the configuration to wezterm
return config
