-- Pull in WezTerm API
local wezterm = require("wezterm")

-- Constants
local window_background_opacity = 0.9

-- Utility functions
local function toggle_window_background_opacity(window)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 1.0
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end
wezterm.on("toggle-window-background-opacity", toggle_window_background_opacity)

local function toggle_ligatures(window)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    overrides.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
  else
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end
wezterm.on("toggle-ligatures", toggle_ligatures)

-- Returns color scheme dependant on operating system theme setting (dark/light)
local function color_scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"  -- Ajuste para um tema claro preferido
  end
end

-- Initialize actual config
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Start tmux when opening WezTerm
config.default_prog = { "/bin/zsh", "-l", "-c", "--", 'tmux new -As base' }
config.skip_close_confirmation_for_processes_named = { "tmux" }

-- Appearance
config.font = wezterm.font_with_fallback {
  "JetBrains Mono Nerd Font",
  "DepartureMono Nerd Font",
}
config.font_size = 11.0
config.color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance())
config.window_background_opacity = window_background_opacity
config.macos_window_background_blur = 10
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false
config.use_fancy_tab_bar = false

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.scrollback_lines = 10000  -- Reduzido para economia de memória

-- Layout
config.window_padding = {
  left = 5,
  right = 0,
  top = 5,
  bottom = 0,
}
config.default_cwd = wezterm.home_dir
config.enable_scroll_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "NeverPrompt"
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- Keybindings
config.keys = {
  { key = "O", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-window-background-opacity") },  -- Toggle opacity
  { key = "E", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-ligatures") },  -- Toggle ligatures
  { key = ",", mods = "SUPER", action = wezterm.action.SpawnCommandInNewWindow({ cwd = os.getenv("WEZTERM_CONFIG_DIR"), args = { os.getenv("SHELL"), "-l", "-c", 'eval "$(mise env zsh)" && source "$XDG_DATA_HOME/bob/env/env.sh" && $VISUAL $WEZTERM_CONFIG_FILE' } }) },  -- Edit config (macOS style)
  { key = "<", mods = "CTRL|SHIFT", action = wezterm.action.SpawnCommandInNewWindow({ cwd = os.getenv("WEZTERM_CONFIG_DIR"), args = { os.getenv("SHELL"), "-l", "-c", 'eval "$(mise env zsh)" && source "$XDG_DATA_HOME/bob/env/env.sh" && $VISUAL $WEZTERM_CONFIG_FILE' } }) },  -- Edit config (alt)
  { key = ">", mods = "CTRL|SHIFT", action = wezterm.action.SpawnCommandInNewWindow({ args = { os.getenv("SHELL"), "-l", "-c", "zsh" } }) },  -- Spawn without tmux
  { key = "n", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },  -- Disable default new window
  { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },  -- New window
}

-- Return config to WezTerm
return config
