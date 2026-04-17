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

-- ── OS DETECTION ─────────────────────────────────────────────────────
local is_macos = wezterm.target_triple:find("apple")
local is_linux = wezterm.target_triple:find("linux")

-- ── FILE HELPERS ─────────────────────────────────────────────────────
local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
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
  },
  ["backend-rust"] = {
    stack = "rust",
    services = { "cargo watch -x run || cargo run" },
  },
}

-- ── PROJECT SCANNER ──────────────────────────────────────────────────
local function scan_projects()
  local home = os.getenv("HOME")

  local stdout = wezterm.run_child_process({
    "bash",
    "-c",
    "find " .. home .. "/prj -maxdepth 1 -type d",
  })

  local projects = {}

  if stdout then
    for line in stdout:gmatch("[^\r\n]+") do
      local name = line:match(".*/(.*)")
      if name and name ~= "prj" then
        table.insert(projects, { name = name, path = line })
      end
    end
  end

  return projects
end

local projects = scan_projects()

-- ── COMMAND RUNNER ───────────────────────────────────────────────────
local function run_commands(window, pane, commands)
  if not commands then return end
  for _, cmd in ipairs(commands) do
    wezterm.sleep_ms(200)
    window:perform_action(act.SendString(cmd .. "\n"), pane)
  end
end

-- ── IDE SESSIONIZER ──────────────────────────────────────────────────
local function open_project_ide(window, pane, project)
  local profile = project_profiles[project.name]
  local stack = profile and profile.stack or detect_stack(project.path)

  window:perform_action(
    act.SwitchToWorkspace {
      name = project.name,
      cwd = project.path,
    },
    pane
  )

  wezterm.sleep_ms(150)

  -- Editor
  window:perform_action(
    act.SpawnTab { cwd = project.path, args = { "nvim" } },
    pane
  )

  wezterm.sleep_ms(150)

  -- Split right
  window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)

  wezterm.sleep_ms(150)

  -- Services
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

  -- Logs
  window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)

  wezterm.sleep_ms(150)

  if stack == "docker" then
    run_commands(window, pane, { "docker compose logs -f" })
  else
    run_commands(window, pane, { "echo 'logs'" })
  end

  -- Git UI
  wezterm.sleep_ms(150)
  window:perform_action(
    act.SpawnTab { cwd = project.path, args = { "lazygit" } },
    pane
  )
end

-- ── FONT ─────────────────────────────────────────────────────────────
config.font_size = is_macos and 12 or 11
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")

-- ── RENDER / PERFORMANCE ─────────────────────────────────────────────
config.front_end = "WebGpu"

if is_linux then
  config.webgpu_power_preference = "HighPerformance"
  config.enable_wayland = true
  config.max_fps = 120
elseif is_macos then
  config.webgpu_power_preference = "HighPerformance"
  config.max_fps = 120
end

config.cursor_blink_rate = 0
config.scrollback_lines = 10000

-- ── APPEARANCE ───────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
  cursor_bg = "#7aa2f7",
  cursor_border = "#7aa2f7",
}
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}

-- ── WINDOW ───────────────────────────────────────────────────────────
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }
config.initial_cols = 220
config.initial_rows = 50

-- macOS specific tweaks
if is_macos then
  config.native_macos_fullscreen_mode = true
end

-- ── TAB BAR ──────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER ───────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }
config.default_workspace = "main"

-- ── KEYBINDINGS ──────────────────────────────────────────────────────
config.keys = {

  -- Workspaces
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },

  -- Sessionizer
  {
    key = "p",
    mods = "LEADER",
    action = act.InputSelector {
      title = "🚀 Projects",
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

  -- Panes
  { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Utilities
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

-- ── MOUSE ────────────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

return config
