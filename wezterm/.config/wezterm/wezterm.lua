local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ── BASICS ────────────────────────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 11
config.line_height = 1.2

config.front_end = "OpenGL"
config.max_fps = 60
config.animation_fps = 30

config.scrollback_lines = 10000
config.cursor_blink_rate = 0

-- ── APPEARANCE ────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}

config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }

-- ── TAB BAR ───────────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER ────────────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 }

-- ── SIMPLE PROJECT LAUNCHER (SEM SCAN AUTOMÁTICO) ─────────────────────────
local projects = {
  { name = "api", path = os.getenv("HOME") .. "/prj/api" },
  { name = "infra", path = os.getenv("HOME") .. "/prj/infra" },
  { name = "backend-rust", path = os.getenv("HOME") .. "/prj/backend-rust" },
}

local function open_project(window, pane, project)
  -- workspace
  window:perform_action(
    act.SwitchToWorkspace {
      name = project.name,
      cwd = project.path,
    },
    pane
  )

  -- editor
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
      args = { "nvim" },
    },
    pane
  )

  -- split + run app
  window:perform_action(
    act.SplitHorizontal { domain = "CurrentPaneDomain" },
    pane
  )

  window:perform_action(
    act.SendString("clear\n"),
    pane
  )

  -- split logs
  window:perform_action(
    act.SplitVertical { domain = "CurrentPaneDomain" },
    pane
  )

  window:perform_action(
    act.SendString("clear\n"),
    pane
  )
end

-- ── KEYBINDINGS ───────────────────────────────────────────────────────────
config.keys = {
  -- launcher
  {
    key = "p",
    mods = "LEADER",
    action = act.InputSelector {
      title = "🚀 Projects",
      choices = (function()
        local t = {}
        for _, p in ipairs(projects) do
          table.insert(t, { id = p.name, label = p.name })
        end
        return t
      end)(),
      action = wezterm.action_callback(function(window, pane, id)
        for _, p in ipairs(projects) do
          if p.name == id then
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

  -- reload
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

-- ── COPY/PASTE ────────────────────────────────────────────────────────────
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

-- ── MOUSE ─────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

return config
