-- Improved wezterm.lua with cleaner structure, performance tweaks,
-- safer defaults, and better maintainability

local wezterm = require("wezterm")
local act = wezterm.action

-- Use config_builder when available
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- ============================================================================
-- APPEARANCE
-- ============================================================================
config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.check_for_updates = false

config.font = wezterm.font_with_fallback({ "JetBrains Mono Nerd Font" })
config.font_size = 11.0
config.harfbuzz_features = { "calt=0" }

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
config.default_cursor_style = "SteadyBar"

config.window_padding = {
  left = 5,
  right = 0,
  top = 5,
  bottom = 0,
}

-- ============================================================================
-- PERFORMANCE / BEHAVIOR
-- ============================================================================
config.default_cwd = wezterm.home_dir
config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.animation_fps = 60
config.max_fps = 120
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- ============================================================================
-- WEZTERM INTEROPERABILITY (recommended for tmux + nvim + wezterm)
-- ============================================================================
-- Tell wezterm to emulate kitty keyboard protocol (helps with complex key maps)
config.enable_kitty_keyboard = true
-- Ensure a stable TERM value outside tmux; tmux will set tmux-256color inside sessions
config.term = "wezterm"

-- ============================================================================
-- KEYS: send Alt/Meta sequences to the shell so tmux/vim receive them as expected
-- ============================================================================
-- Goal: Alt-h/j/k/l -> navigate panes in tmux/nvim; Alt+Shift -> resize; digits Alt+1..9 -> select windows
config.keys = {
  -- Alt + h/j/k/l -> send ESC + letter (Meta key)
  { key = "h", mods = "ALT", action = act.SendString("\x1bh") },
  { key = "j", mods = "ALT", action = act.SendString("\x1bj") },
  { key = "k", mods = "ALT", action = act.SendString("\x1bk") },
  { key = "l", mods = "ALT", action = act.SendString("\x1bl") },

  -- Alt+Shift H/J/K/L -> send ESC + uppercase letter (Meta+Shift)
  { key = "H", mods = "ALT|SHIFT", action = act.SendString("\x1bH") },
  { key = "J", mods = "ALT|SHIFT", action = act.SendString("\x1bJ") },
  { key = "K", mods = "ALT|SHIFT", action = act.SendString("\x1bK") },
  { key = "L", mods = "ALT|SHIFT", action = act.SendString("\x1bL") },

  -- Copy / Paste (Ctrl+Shift C / V)
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- Open links with mouse is kept; these keys help tmux window selection via Alt+1..9
}

-- Dynamically add Alt+1..9 and Alt+0 (0 -> 10th)
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = "ALT", action = act.SendString("\x1b" .. tostring(i)) })
end
-- Alt+0 -> send ESC+0
table.insert(config.keys, { key = "0", mods = "ALT", action = act.SendString("\x1b0") })

-- ============================================================================
-- MOUSE BINDINGS
-- ============================================================================
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.OpenLinkAtMouseCursor,
  },
}

-- ============================================================================
-- STATUS BAR (right side)
-- ============================================================================
wezterm.on("update-right-status", function(window, _)
  local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#89b4fa" } },
    { Text = " " .. date .. " " },
  }))
end)

-- ============================================================================
-- TAB TITLE CUSTOMIZATION
-- ============================================================================
wezterm.on("format-tab-title", function(tab)
  local pane = tab.active_pane

  local cwd_uri = pane.current_working_dir
  local cwd = cwd_uri and (cwd_uri.file_path or cwd_uri.path) or ""
  if cwd ~= "" then
    cwd = cwd:gsub("^.*[/\\]([^/\\]+)[/\\]?$", "%1")
  end

  local process = pane.foreground_process_name or ""
  return cwd .. " - " .. process
end)

-- ============================================================================
-- RETURN
-- ============================================================================
return config
