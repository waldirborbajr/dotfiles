local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Font & Rendering
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Performance: renderer & GPU
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true

-- Colors & Appearance
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}

-- Window
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }
config.window_background_opacity = 1.0
config.initial_cols = 220
config.initial_rows = 50

-- Scrollback & Performance
config.scrollback_lines = 10000
config.max_fps = 120
config.cursor_blink_rate = 0

-- Tab bar
config.enable_tab_bar = true          -- habilitado para suporte a tabs
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true  -- esconde se houver só uma tab

-- Keys
config.keys = {
  -- ── TABS ─────────────────────────────────────────────────────────────
  { key = "t",         mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w",         mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "Tab",       mods = "CTRL",       action = act.ActivateTabRelative(1) },
  { key = "Tab",       mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "1",         mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
  { key = "2",         mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
  { key = "3",         mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
  { key = "4",         mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
  { key = "5",         mods = "CTRL|SHIFT", action = act.ActivateTab(4) },

  -- ── PANES ────────────────────────────────────────────────────────────
  { key = "w", mods = "CMD",       action = act.CloseCurrentPane({ confirm = false }) },
  { key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

  -- Pane navigation
  { key = "LeftArrow",  mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow",  mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },

  -- Pane resize
  { key = "LeftArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Left",  5 }) },
  { key = "RightArrow", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow",    mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Up",    5 }) },
  { key = "DownArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Down",  5 }) },

  -- ── MISC ─────────────────────────────────────────────────────────────
  { key = "l",     mods = "CTRL",       action = act.SendString("clear\n") },
  { key = "=",     mods = "CTRL",       action = act.IncreaseFontSize },
  { key = "-",     mods = "CTRL",       action = act.DecreaseFontSize },
  { key = "0",     mods = "CTRL",       action = act.ResetFontSize },
  { key = "c",     mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },
  { key = "o",     mods = "CTRL|SHIFT", action = act.OpenLinkAtMouseCursor },
}

-- Mouse
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
  {
    event = { Down = { streak = 1, button = "Middle" } },
    mods = "NONE",
    action = act.OpenLinkAtMouseCursor,
  },
}

-- SSH
config.ssh_domains = {
  {
    name = "rpi",
    remote_address = "192.168.1.110",
    username = "raspi",
    ssh_option = { identityfile = "~/.ssh/id_ed25519" },
  },
}

return config
