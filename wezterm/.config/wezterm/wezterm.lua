local wezterm = require("wezterm")
local act = wezterm.action

local config = {
  -- ── CORE ────────────────────────────────────────────────────────────────
  front_end = "OpenGL",
  max_fps = 60,
  animation_fps = 30,

  -- ── FONT ────────────────────────────────────────────────────────────────
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 11,
  line_height = 1.2,

  -- ── BUFFER ──────────────────────────────────────────────────────────────
  scrollback_lines = 10000,
  cursor_blink_rate = 0,

  -- ── UI ──────────────────────────────────────────────────────────────────
  color_scheme = "Catppuccin Macchiato",
  window_decorations = "RESIZE",
  window_padding = { left = 8, right = 8, top = 6, bottom = 0 },

  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,

  -- ── LEADER ──────────────────────────────────────────────────────────────
  leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 },
}

-- ── PROJECTS (EXPLÍCITO = CONFIÁVEL) ──────────────────────────────────────
local HOME = os.getenv("HOME")

local projects = {
  { id = "api", path = HOME .. "/prj/api" },
  { id = "infra", path = HOME .. "/prj/infra" },
  { id = "rust", path = HOME .. "/prj/backend-rust" },
}

-- ── CORE ACTION (SEM RACE CONDITION) ──────────────────────────────────────
local function open_project(window, pane, project)
  -- workspace isolado
  window:perform_action(
    act.SwitchToWorkspace {
      name = project.id,
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

  -- shell limpo
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
    },
    pane
  )
end

-- ── KEYS ──────────────────────────────────────────────────────────────────
config.keys = {
  -- launcher de projetos
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

  -- reload seguro
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

-- ── COPY / PASTE ──────────────────────────────────────────────────────────
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
