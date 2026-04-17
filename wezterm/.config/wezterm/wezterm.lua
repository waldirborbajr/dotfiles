--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/
----

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ── PLATFORM DETECTION ──────────────────────────────────────────────────
local function is_macos()
  return string.find(wezterm.target_triple, "apple%-darwin") ~= nil
end

local function is_linux()
  return string.find(wezterm.target_triple, "unknown%-linux") ~= nil
end

local IS_MACOS = is_macos()
local IS_LINUX = is_linux()

-- ── FILE HELPERS ─────────────────────────────────────────────────────
local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- ── STACK DETECTION ──────────────────────────────────────────────────
local function detect_stack(path)
  if file_exists(path .. "/docker-compose.yml") then
    return "docker"
  elseif file_exists(path .. "/Cargo.toml") then
    return "rust"
  elseif file_exists(path .. "/go.mod") then
    return "go"
  else
    return "unknown"
  end
end

-- ── PROJECT PROFILES ─────────────────────────────────────────────────
local project_profiles = {
  ["infra"] = {
    stack = "docker",
    services = { "docker compose up" },
    logs = { "docker compose logs -f" },
  },
  ["api"] = {
    stack = "go",
    services = { "air || go run ." },
    logs = { "echo 'Go logs - use air for hot reload'" },
  },
  ["backend-rust"] = {
    stack = "rust",
    services = { "cargo watch -x run || cargo run" },
    logs = { "echo 'Rust logs'" },
  },
}

-- ── PROJECT SCANNER (melhor dos dois) ────────────────────────────────
local function scan_projects()
  local home = os.getenv("HOME")
  local projects_dir = home .. "/prj"

  -- Fallback para ~/dev se ~/prj não existir
  if not file_exists(projects_dir) then
    projects_dir = home .. "/dev"
  end

  if not file_exists(projects_dir) then
    return {}
  end

  local stdout = wezterm.run_child_process({
    "bash",
    "-c",
    "find " .. projects_dir .. " -maxdepth 1 -type d 2>/dev/null | tail -n +2",
  })

  local projects = {}
  if stdout then
    for line in stdout:gmatch("[^\r\n]+") do
      local name = line:match(".*/(.*)")
      if name and name ~= "" and name ~= "prj" and name ~= "dev" then
        table.insert(projects, { name = name, path = line })
      end
    end
  end
  return projects
end

local projects = scan_projects()

-- ── COMMAND RUNNER (otimizado) ───────────────────────────────────────
local function run_commands(window, pane, commands)
  if not commands then return end

  -- Delay menor no Linux, um pouco maior no macOS para estabilidade
  local delay = IS_MACOS and 80 or 40

  for _, cmd in ipairs(commands) do
    wezterm.sleep_ms(delay)
    window:perform_action(act.SendString(cmd .. "\n"), pane)
  end
end

-- ── IDE SESSIONIZER (melhorado) ──────────────────────────────────────
local function open_project_ide(window, pane, project)
  local profile = project_profiles[project.name]
  local stack = profile and profile.stack or detect_stack(project.path)

  -- Delay base adaptativo
  local delay = IS_MACOS and 100 or 60

  -- Switch workspace
  window:perform_action(
    act.SwitchToWorkspace { name = project.name, cwd = project.path },
    pane
  )
  wezterm.sleep_ms(delay)

  -- Tab 1: Neovim
  window:perform_action(
    act.SpawnTab { cwd = project.path, args = { "nvim" } },
    pane
  )
  wezterm.sleep_ms(delay)

  -- Split horizontal → Services pane
  window:perform_action(act.SplitHorizontal { domain = "CurrentPaneDomain" }, pane)
  wezterm.sleep_ms(delay)

  if profile and profile.services then
    run_commands(window, pane, profile.services)
  else
    if stack == "docker" then
      run_commands(window, pane, { "docker compose up" })
    elseif stack == "go" then
      run_commands(window, pane, { "go run ." })
    elseif stack == "rust" then
      run_commands(window, pane, { "cargo run" })
    end
  end

  -- Split vertical → Logs pane
  window:perform_action(act.SplitVertical { domain = "CurrentPaneDomain" }, pane)
  wezterm.sleep_ms(delay)

  if profile and profile.logs then
    run_commands(window, pane, profile.logs)
  else
    if stack == "docker" then
      run_commands(window, pane, { "docker compose logs -f" })
    else
      run_commands(window, pane, { "echo 'No logs configured'" })
    end
  end

  -- Nova tab: Lazygit
  wezterm.sleep_ms(delay)
  window:perform_action(
    act.SpawnTab { cwd = project.path, args = { "lazygit" } },
    pane
  )
end

-- ── FONT & RENDERING (melhor dos dois) ───────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = IS_MACOS and 12 or 11
config.line_height = IS_MACOS and 1.3 or 1.2

-- Performance otimizada
if IS_MACOS then
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "LowPower"        -- mais eficiente em Mac
  config.max_fps = 60
  config.animation_fps = 30
  config.macos_window_background_blur = 0
else -- Linux
  config.front_end = "WebGpu"                        -- preferível quando funciona bem
  config.webgpu_power_preference = "HighPerformance"
  config.enable_wayland = true
  config.max_fps = 120
  config.animation_fps = 60
end

config.scrollback_lines = 10000
config.cursor_blink_rate = 0
config.harfbuzz_features = { "calt=0", "liga=0" } -- desativa ligaduras para performance

-- ── APPEARANCE ───────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- ── WINDOW SETTINGS ──────────────────────────────────────────────────
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }
config.initial_cols = 200
config.initial_rows = 48

if IS_MACOS then
  config.native_macos_fullscreen_mode = true
end

-- ── TAB BAR ──────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false

-- ── LEADER & DEFAULT ─────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 }
config.default_workspace = "main"

-- ── KEYBINDINGS ──────────────────────────────────────────────────────
config.keys = {
  -- Workspaces
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },
  { key = "W", mods = "LEADER|SHIFT", action = act.SwitchToWorkspace },

  -- Projects Sessionizer (melhor feature)
  {
    key = "p",
    mods = "LEADER",
    action = act.InputSelector {
      title = "🚀 Open Project",
      choices = (function()
        local choices = {}
        for _, proj in ipairs(projects) do
          table.insert(choices, {
            id = proj.name,
            label = "📁 " .. proj.name,
          })
        end
        return choices
      end)(),
      action = wezterm.action_callback(function(window, pane, id)
        if not id then return end
        for _, proj in ipairs(projects) do
          if proj.name == id then
            open_project_ide(window, pane, proj)
            return
          end
        end
      end),
    },
  },

  -- Tabs
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "P", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },

  -- Panes
  { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Resize
  { key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Utilities
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
  { key = "s", mods = "LEADER", action = act.ShowLauncher },
}

-- Platform specific copy/paste
if IS_MACOS then
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
  table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
end

-- ── MOUSE ────────────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

-- ── SSH DOMAINS ──────────────────────────────────────────────────────
config.ssh_domains = {
  {
    name = "rpi",
    remote_address = "192.168.1.110",
    username = "raspi",
    ssh_option = { identityfile = "~/.ssh/id_ed25519" },
  },
}

return config
