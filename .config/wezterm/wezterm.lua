--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file
---
--- https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm

local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux
-- local mod = 'SHIFT|SUPER'

wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window(cmd or {})
  -- local gui_window = window:gui_window()
  -- gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
  window:gui_window():maximize()
end)

local config = {
  color_scheme = 'catppuccin-frappe',

  font = wezterm.font(' CommitMono Nerd Font', { weight = 'Medium', stretch = 'Normal', style = 'Normal' }),
  font_size = 11,
  freetype_load_flags = 'DEFAULT',
  -- front_end = 'WebGpu',

  -- max_fps = 75,
  -- animation_fps = 75,

  default_prog = { '/usr/bin/env', 'zsh' },

  hide_mouse_cursor_when_typing = true,

  hide_tab_bar_if_only_one_tab = true,

  use_fancy_tab_bar = false,
  status_update_interval = 1000,
  tab_bar_at_bottom = false,

  window_padding = {
    left = '0.5cell',
    right = '0.5cell',
    top = '0.5cell',
    bottom = '0cell',
  },

  window_background_opacity = 0.95,
  window_decorations = 'RESIZE',
  window_close_confirmation = 'AlwaysPrompt',
  scrollback_lines = 3000,
  default_workspace = 'main',

  launch_menu = {
    {
      label = 'Pi4-wired',
      args = { 'ssh', 'borba@192.168.1.19' },
    },
    {
      label = 'Mi-wired',
      args = { 'ssh', '-b', '10.0.0.1', '-t', 'martins3@10.0.0.2', 'zellij attach || zellij' },
    },
    {
      label = 'M2',
      args = { 'ssh', '-t', 'martins3@192.168.11.99', 'zellij attach || zellij' },
    },
    {
      label = 'Mi',
      args = { 'ssh', '-t', 'martins3@192.168.11.17', 'zellij attach || zellij' },
    },
    {
      label = 'zellij',
      args = { '/bin/sh', '-l', '-c', 'zellij attach || zellij' },
    },
    {
      label = 'QEMU',
      args = { 'ssh', '-t', '-p5556', 'root@localhost', 'zellij attach || zellij' },
    },
    {
      label = 'bare',
      args = { 'zsh' },
    },
  },

  -- Define leader key C-a
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },

  keys = {
    { key = 'h', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = 'v', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = 'Z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = '[', mods = 'ALT', action = act.ActivatePaneDirection('Prev') },
    { key = ']', mods = 'ALT', action = act.ActivatePaneDirection('Next') },

    { key = 'k', mods = 'ALT|SHIFT', action = act.CloseCurrentPane({ confirm = false }) },
    {
      key = 'k',
      mods = 'ALT',
      action = act.Multiple({
        act.ClearScrollback('ScrollbackAndViewport'),
        act.SendKey({ key = 'L', mods = 'CTRL' }),
      }),
    },
    {
      key = ',',
      mods = 'ALT',
      action = act.SpawnCommandInNewTab({
        cwd = os.getenv('WEZTERM_CONFIG_DIR'),
        set_environment_variables = {
          TERM = 'screen-256color',
        },
        args = {
          '/home/borba/bins/nvim',
          os.getenv('WEZTERM_CONFIG_FILE'),
        },
      }),
    },
    { key = 't', mods = 'ALT', action = act.SpawnTab('CurrentPaneDomain') },
    { key = 't', mods = 'CTRL|ALT', action = wezterm.action.ShowTabNavigator },
    { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
    { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
    { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
    { key = 'F4', mods = 'NONE', action = act.ShowTabNavigator },
    { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
    { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },
    { key = 'h', mods = 'CTRL', action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'j', mods = 'CTRL', action = act.AdjustPaneSize({ 'Down', 1 }) },
    { key = 'k', mods = 'CTRL', action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'l', mods = 'CTRL', action = act.AdjustPaneSize({ 'Right', 1 }) },
  },
}

return config
