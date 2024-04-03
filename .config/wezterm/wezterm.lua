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

  status_update_interval = 1000,

  window_padding = {
    left = 2.5,
    right = 2.5,
    top = 2.5,
    bottom = 4.5,
  },

  -- Tab Bar
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  show_new_tab_button_in_tab_bar = false,

  -- general options
  adjust_window_size_when_changing_font_size = false,
  debug_key_events = false,
  native_macos_fullscreen_mode = false,
  -- window_close_confirmation = 'NeverPrompt',
  -- window_decorations = 'RESIZE',

  window_background_opacity = 0.95,
  window_decorations = 'RESIZE',
  window_close_confirmation = 'AlwaysPrompt',
  scrollback_lines = 3000,

  set_environment_variables = {
    TERM = 'xterm-256color',
    LC_ALL = 'en_US.UTF-8',
  },

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
  -- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },

  keys = {
    { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom('Clipboard') },
    { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom('PrimarySelection') },
    { key = 'w', mods = 'ALT', action = wezterm.action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },
    -- { key = 'h', mods = 'ALT', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    -- { key = 'v', mods = 'ALT', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = '.', mods = 'ALT', action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
    { key = '-', mods = 'ALT', action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
    { key = 't', mods = 'ALT', action = act.SpawnTab('CurrentPaneDomain') },
    { key = 't', mods = 'ALT|SHIFT', action = wezterm.action.ShowTabNavigator },
    { key = 'f', mods = 'ALT', action = 'TogglePaneZoomState' },
    { key = '[', mods = 'ALT', action = act.ActivatePaneDirection('Prev') },
    { key = ']', mods = 'ALT', action = act.ActivatePaneDirection('Next') },
    { key = 'h', mods = 'CTRL', action = act.AdjustPaneSize({ 'Left', 2 }) },
    { key = 'j', mods = 'CTRL', action = act.AdjustPaneSize({ 'Down', 2 }) },
    { key = 'k', mods = 'CTRL', action = act.AdjustPaneSize({ 'Up', 2 }) },
    { key = 'l', mods = 'CTRL', action = act.AdjustPaneSize({ 'Right', 2 }) },
    { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Right') },
    { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'n', mods = 'ALT', action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = 'p', mods = 'ALT', action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = '1', mods = 'ALT', action = wezterm.action({ ActivateTab = 0 }) },
    { key = '2', mods = 'ALT', action = wezterm.action({ ActivateTab = 1 }) },
    { key = '3', mods = 'ALT', action = wezterm.action({ ActivateTab = 2 }) },
    { key = '4', mods = 'ALT', action = wezterm.action({ ActivateTab = 3 }) },
    { key = '5', mods = 'ALT', action = wezterm.action({ ActivateTab = 4 }) },
    { key = '6', mods = 'ALT', action = wezterm.action({ ActivateTab = 5 }) },
    { key = '7', mods = 'ALT', action = wezterm.action({ ActivateTab = 6 }) },
    { key = '8', mods = 'ALT', action = wezterm.action({ ActivateTab = 7 }) },
    { key = '9', mods = 'ALT', action = wezterm.action({ ActivateTab = 8 }) },
    { key = 'm', mods = 'ALT', action = wezterm.action.ActivateCopyMode },
    { key = '&', mods = 'ALT|SHIFT', action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
    { key = 'x', mods = 'ALT', action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
    { key = 'n', mods = 'SHIFT|CTRL', action = 'ToggleFullScreen' },
    -- {
    --   mods = 'CMD|SHIFT',
    --   key = '}',
    --   action = act.Multiple({
    --     act.SendKey({ mods = 'CTRL', key = 'b' }),
    --     act.SendKey({ key = 'n' }),
    --   }),
    -- },
    { key = 'k', mods = 'ALT|SHIFT', action = act.CloseCurrentPane({ confirm = true }) },
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
    { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
    { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
    { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
    { key = 'F4', mods = 'NONE', action = act.ShowTabNavigator },
    { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
    { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },
  },
}

return config
