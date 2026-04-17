local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action  -- alias for cleaner key bindings

-- Font & Rendering
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.freetype_load_target = "Light"         -- smoother font rendering
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9                        -- tighten character spacing

-- Colors & Appearance
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
  -- dim inactive panes visually
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.6,
  },
}

-- Window
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }
config.window_background_opacity = 0.95       -- subtle transparency
config.macos_window_background_blur = 20      -- blur (macOS only)
config.initial_cols = 220
config.initial_rows = 50

-- Scrollback
config.scrollback_lines = 10000

-- Tab bar (hidden but configured for when you need it)
config.enable_tab_bar = false
config.use_fancy_tab_bar = false

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Pane navigation with CTRL+arrows (no plugin needed)
local function pane_nav(dir)
  return act.ActivatePaneDirection(dir)
end

config.keys = {
  -- Your existing keys
  { key = "w", mods = "CMD",        action = act.CloseCurrentPane({ confirm = false }) },
  { key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "l", mods = "CTRL",       action = act.SendString("clear\n") },

  -- Pane navigation
  { key = "LeftArrow",  mods = "CTRL|SHIFT", action = pane_nav("Left") },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = pane_nav("Right") },
  { key = "UpArrow",    mods = "CTRL|SHIFT", action = pane_nav("Up") },
  { key = "DownArrow",  mods = "CTRL|SHIFT", action = pane_nav("Down") },

  -- Pane resize
  { key = "LeftArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "RightArrow", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "UpArrow",    mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "DownArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 5 }) },

  -- Zoom current pane (toggle)
  { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

  -- Quick font size
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },

  -- Copy mode (vim-like selection)
  { key = "c", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },

  -- Quick select (grab URLs, IPs, paths, etc.)
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },

  -- Open URL under cursor
  { key = "o", mods = "CTRL|SHIFT", action = act.OpenLinkAtMouseCursor },
}

-- Right-click pastes, middle-click opens link
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

config.ssh_domains = {
  {
    name = "rpi",
    remote_address = "192.168.1.110",
    username = "raspi",
    ssh_option = { identityfile = "~/.ssh/id_ed25519" },
  },
}

return config
