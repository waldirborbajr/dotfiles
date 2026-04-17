local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- ── PLATFORM DETECTION ─────────────────────────────────────────────────────
local is_macos = wezterm.target_triple:find("apple") ~= nil

-- ── CORE (STABLE RENDERING) ────────────────────────────────────────────────
if is_macos then
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "LowPower" -- ideal p/ M1/M2
  config.max_fps = 60
  config.animation_fps = 60
else
  config.front_end = "OpenGL" -- mais estável no Linux
  config.max_fps = 60
  config.animation_fps = 30
end

-- ── FONT ──────────────────────────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = is_macos and 12 or 11
config.line_height = 1.2

-- ── PERFORMANCE ───────────────────────────────────────────────────────────
config.scrollback_lines = 10000
config.cursor_blink_rate = 0
config.enable_scroll_bar = false

-- ── APPEARANCE ────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"

config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 0,
}

if is_macos then
  config.native_macos_fullscreen_mode = true
end

-- ── TAB BAR ───────────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER ────────────────────────────────────────────────────────────────
config.leader = {
  key = "a",
  mods = "CTRL",
  timeout_milliseconds = 600,
}

-- ── PROJECTS (EXPLÍCITO = ROBUSTO) ─────────────────────────────────────────
local HOME = os.getenv("HOME")

local projects = {
  { id = "api", path = HOME .. "/prj/api" },
  { id = "infra", path = HOME .. "/prj/infra" },
  { id = "rust", path = HOME .. "/prj/backend-rust" },
}

-- ── SAFE WORKSPACE LAUNCHER ───────────────────────────────────────────────
local function open_project(window, pane, project)
  -- workspace isolado
  window:perform_action(
    act.SwitchToWorkspace {
      name = project.id,
      cwd = project.path,
    },
    pane
  )

  -- editor (tab 1)
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
      args = { "nvim" },
    },
    pane
  )

  -- shell (tab 2)
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
    },
    pane
  )
end

-- ── KEYBINDINGS ───────────────────────────────────────────────────────────
config.keys = {
  -- project launcher
  {
    key = "p",
    mods = "LEADER",
    action = act.InputSelector {
      title = "Projects",
      choices = (function()
        local t = {}
        for _, p in ipairs(projects) do
          table.insert(t, { id = p.id, label = p.id })
        end
        return t
      end)(),
      action = wezterm.action_callback(function(window, pane, id)
        if not id then return end
        for _, p in ipairs(projects) do
          if p.id == id then
            open_project(window, pane, p)
            return
          end
        end
      end),
    },
  },

  -- tabs
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },

  -- panes
  { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- reload config
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

-- ── COPY / PASTE ──────────────────────────────────────────────────────────
if is_macos then
  table.insert(config.keys, {
    key = "v",
    mods = "CMD",
    action = act.PasteFrom("Clipboard"),
  })

  table.insert(config.keys, {
    key = "c",
    mods = "CMD",
    action = act.CopyTo("Clipboard"),
  })
else
  table.insert(config.keys, {
    key = "v",
    mods = "CTRL|SHIFT",
    action = act.PasteFrom("Clipboard"),
  })

  table.insert(config.keys, {
    key = "c",
    mods = "CTRL|SHIFT",
    action = act.CopyTo("Clipboard"),
  })
end

-- ── MOUSE ─────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

return config
