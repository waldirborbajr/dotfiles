--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require('wezterm')
local act = wezterm.action

local config = {
  -- font = wezterm.font('JetBrainsMono Nerd Font'),
  font = wezterm.font('FiraCode Nerd Font', { weight = 'Medium', stretch = 'Normal', style = 'Normal' }),
  font_size = 12.0,
  color_scheme = 'catppuccin-frappe',

  default_prog = { '/usr/bin/env', 'zsh' },

  hide_mouse_cursor_when_typing = true,

  hide_tab_bar_if_only_one_tab = true,

  window_padding = {
    left = '0.5cell',
    right = '0.5cell',
    top = '0.5cell',
    bottom = '0cell',
  },

  window_background_opacity = 0.9,
  window_decorations = 'RESIZE',
  window_close_confirmation = 'AlwaysPrompt',
  scrollback_lines = 3000,
  default_workspace = 'main',

  keys = {
    { key = 'd', mods = 'ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = 'd', mods = 'ALT|SHIFT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = 'k', mods = 'ALT|SHIFT', action = act.CloseCurrentPane({ confirm = false }) },
    {
      key = 'k',
      mods = 'ALT',
      action = act.Multiple({
        act.ClearScrollback('ScrollbackAndViewport'),
        act.SendKey({ key = 'L', mods = 'CTRL' }),
      }),
    },
    { key = '[', mods = 'ALT', action = act.ActivatePaneDirection('Prev') },
    { key = ']', mods = 'ALT', action = act.ActivatePaneDirection('Next') },
    { key = 't', mods = 'ALT', action = act.SpawnTab('CurrentPaneDomain') },
    { key = 'Enter', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },
  },
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

return config
