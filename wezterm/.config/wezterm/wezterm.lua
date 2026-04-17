local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local function scan_projects()
  local home = os.getenv("HOME")
  local dirs = wezterm.run_child_process({
    "bash",
    "-c",
    "find " .. home .. "/dev -maxdepth 1 -type d",
  })

  local projects = {}
  for line in dirs:gmatch("[^\r\n]+") do
    local name = line:match(".*/(.*)")
    table.insert(projects, { name = name, path = line })
  end

  return projects
end

local projects = scan_projects()

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

-- Leader (prefixo estilo tmux)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }

-- ── WORKSPACES (session-like) ─────────────────────────────────────────
-- Alternar entre workspaces (tipo session switcher)
{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },

-- Criar novo workspace com nome
{ key = "W", mods = "LEADER|SHIFT", action = act.PromptInputLine {
  description = "New Workspace Name",
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:perform_action(
        act.SwitchToWorkspace {
          name = line,
        },
        pane
      )
    end
  end),
} },

-- Criar workspace rápido (nome automático)
{ key = "n", mods = "LEADER|SHIFT", action = act.SwitchToWorkspace },

-- ── SESSIONIZER (fzf-like) ────────────────────────────────────────────
{
  key = "p",
  mods = "LEADER",
  action = act.InputSelector {
    title = "Select Project",
    choices = (function()
      local choices = {}
      for _, proj in ipairs(projects) do
        table.insert(choices, {
          id = proj.name,
          label = proj.name .. " (" .. proj.path .. ")",
        })
      end
      return choices
    end)(),
    action = wezterm.action_callback(function(window, pane, id, label)
      if not id then return end

      for _, proj in ipairs(projects) do
        if proj.name == id then
          -- muda/cria workspace
          window:perform_action(
            act.SwitchToWorkspace {
              name = proj.name,
              cwd = proj.path,
            },
            pane
          )

          -- opcional: abre nvim automaticamente
          window:perform_action(
            act.SpawnTab {
              cwd = proj.path,
              args = { "nvim" },
            },
            pane
          )

          return
        end
      end
    end),
  },
},

-- ── LEADER (tmux-style) ───────────────────────────────────────────────
-- Tabs
{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

-- Navegação direta por número (1–9)
{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },

-- ── PANES ────────────────────────────────────────────────────────────
-- Split igual tmux (% e ")
{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

-- Fechar pane
{ key = "x", mods = "LEADER|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

-- Zoom pane (toggle)
{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

-- Navegação estilo vim (hjkl)
{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

-- Resize panes (HJKL)
{ key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
{ key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
{ key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
{ key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

-- ── UTILIDADES ───────────────────────────────────────────────────────
-- Copy mode (igual tmux prefix + [)
{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

-- Renomear tab
{ key = ",", mods = "LEADER", action = act.PromptInputLine {
  description = "Rename tab",
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
} },

-- Reload config
{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

-- Abrir launcher (tipo tmux choose-tree)
{ key = "s", mods = "LEADER", action = act.ShowLauncher },

-- -- Keys
-- config.keys = {
--   -- ── TABS ─────────────────────────────────────────────────────────────
--   { key = "t",         mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
--   { key = "w",         mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
--   { key = "Tab",       mods = "CTRL",       action = act.ActivateTabRelative(1) },
--   { key = "Tab",       mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
--   { key = "1",         mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
--   { key = "2",         mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
--   { key = "3",         mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
--   { key = "4",         mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
--   { key = "5",         mods = "CTRL|SHIFT", action = act.ActivateTab(4) },

--   -- ── PANES ────────────────────────────────────────────────────────────
--   { key = "w", mods = "CMD",       action = act.CloseCurrentPane({ confirm = false }) },
--   { key = "v", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
--   { key = "h", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
--   { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

--   -- Pane navigation
--   { key = "LeftArrow",  mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
--   { key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
--   { key = "UpArrow",    mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
--   { key = "DownArrow",  mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },

--   -- Pane resize
--   { key = "LeftArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Left",  5 }) },
--   { key = "RightArrow", mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
--   { key = "UpArrow",    mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Up",    5 }) },
--   { key = "DownArrow",  mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ "Down",  5 }) },

--   -- ── MISC ─────────────────────────────────────────────────────────────
--   { key = "l",     mods = "CTRL",       action = act.SendString("clear\n") },
--   { key = "=",     mods = "CTRL",       action = act.IncreaseFontSize },
--   { key = "-",     mods = "CTRL",       action = act.DecreaseFontSize },
--   { key = "0",     mods = "CTRL",       action = act.ResetFontSize },
--   { key = "c",     mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
--   { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },
--   { key = "o",     mods = "CTRL|SHIFT", action = act.OpenLinkAtMouseCursor },
-- }

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
