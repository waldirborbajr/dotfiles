-- ─────────────────────────────────────────────────────────────────────────────
-- WezTerm Configuration - Fixed & Clean Version
-- ─────────────────────────────────────────────────────────────────────────────

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ── PLATFORM DETECTION ─────────────────────────────────────────────────────
local function is_macos()
  return string.find(wezterm.target_triple, "apple%-darwin") ~= nil
end

local function is_linux()
  return string.find(wezterm.target_triple, "unknown%-linux") ~= nil
end

local IS_MACOS = is_macos()
local IS_LINUX = is_linux()

-- ── FILE HELPERS ───────────────────────────────────────────────────────────
local function file_exists(path)
  local f = io.open(path, "r")
  if f then 
    f:close() 
    return true 
  end
  return false
end

-- ── STACK DETECTION ────────────────────────────────────────────────────────
local function detect_stack(path)
  if file_exists(path .. "/docker-compose.yml") then return "docker" end
  if file_exists(path .. "/Cargo.toml") then return "rust" end
  if file_exists(path .. "/go.mod") then return "go" end
  return "unknown"
end

-- ── PROJECT PROFILES ───────────────────────────────────────────────────────
local project_profiles = {
  ["infra"] = { stack = "docker", services = { "docker compose up" }, logs = { "docker compose logs -f" } },
  ["api"] = { stack = "go", services = { "air || go run ." }, logs = { "echo 'Go logs - air running'" } },
  ["backend-rust"] = { stack = "rust", services = { "cargo watch -x run || cargo run" }, logs = { "echo 'Rust logs'" } },
}

-- ── PROJECT SCANNER (FIXED) ────────────────────────────────────────────────
local function scan_projects()
  local home = os.getenv("HOME")
  local dir = home .. "/prj"
  if not file_exists(dir) then
    dir = home .. "/dev"
  end
  if not file_exists(dir) then
    wezterm.log_warn("Neither ~/prj nor ~/dev directory found")
    return {}
  end

  local success, stdout, stderr = wezterm.run_child_process({
    "bash", "-c",
    "find " .. dir .. " -maxdepth 1 -type d 2>/dev/null | tail -n +2"
  })

  if not success then
    wezterm.log_error("Failed to scan projects in " .. dir .. (stderr and ": " .. stderr or ""))
    return {}
  end

  if not stdout or stdout == "" then
    return {}
  end

  local projects = {}
  for line in stdout:gmatch("[^\r\n]+") do
    local name = line:match(".*/(.*)")
    if name and name ~= "" and name ~= "prj" and name ~= "dev" then
      table.insert(projects, { name = name, path = line })
    end
  end

  return projects
end

-- Scan projects AFTER function definition
local projects = scan_projects()

-- ── COMMAND RUNNER ─────────────────────────────────────────────────────────
local function run_commands(window, pane, commands)
  if not commands then return end
  local delay = IS_MACOS and 80 or 40
  for _, cmd in ipairs(commands) do
    wezterm.sleep_ms(delay)
    window:perform_action(act.SendString(cmd .. "\n"), pane)
  end
end

-- ── IDE SESSIONIZER ────────────────────────────────────────────────────────
local function open_project_ide(window, pane, project)
  local profile = project_profiles[project.name]
  local stack = profile and profile.stack or detect_stack(project.path)
  local delay = IS_MACOS and 100 or 60

  window:perform_action(act.SwitchToWorkspace { name = project.name, cwd = project.path }, pane)
  wezterm.sleep_ms(delay)

  window:perform_action(act.SpawnTab { cwd = project.path, args = { "nvim" } }, pane)
  wezterm.sleep_ms(delay)

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

  wezterm.sleep_ms(delay)
  window:perform_action(act.SpawnTab { cwd = project.path, args = { "lazygit" } }, pane)
end

-- ── FONT & PERFORMANCE ─────────────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = IS_MACOS and 12 or 11
config.line_height = IS_MACOS and 1.3 or 1.2

if IS_MACOS then
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "LowPower"
  config.max_fps = 60
  config.animation_fps = 30
  config.macos_window_background_blur = 0
else
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  config.enable_wayland = true
  config.max_fps = 120
  config.animation_fps = 60
end

config.scrollback_lines = 10000
config.cursor_blink_rate = 0
config.harfbuzz_features = { "calt=0", "liga=0" }

-- ── APPEARANCE ─────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.colors = { cursor_bg = "#7aa2f7", cursor_border = "#7aa2f7" }
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }

-- ── WINDOW ─────────────────────────────────────────────────────────────────
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 0 }
config.initial_cols = 200
config.initial_rows = 48
if IS_MACOS then 
  config.native_macos_fullscreen_mode = true 
end

-- ── TAB BAR ────────────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER ─────────────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 }
config.default_workspace = "main"

-- ── SSH DOMAINS ────────────────────────────────────────────────────────────
local ssh_hosts = wezterm.default_ssh_domains()
for _, dom in ipairs(ssh_hosts) do
  dom.assume_shell = "Posix"
  dom.local_echo_threshold_ms = 250
  dom.timeout = 120
end
config.ssh_domains = ssh_hosts

-- ── KEYBINDINGS ────────────────────────────────────────────────────────────
config.keys = {
  -- Workspaces
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },
  { key = "W", mods = "LEADER|SHIFT", action = act.SwitchToWorkspace },

  -- Projects (LEADER + p)
  {
    key = "p", mods = "LEADER",
    action = act.InputSelector {
      title = "🚀 Open Project",
      choices = (function()
        local choices = {}
        for _, proj in ipairs(projects or {}) do
          table.insert(choices, { id = proj.name, label = "📁 " .. proj.name })
        end
        return choices
      end)(),
      action = wezterm.action_callback(function(window, pane, id)
        if not id then return end
        for _, proj in ipairs(projects or {}) do
          if proj.name == id then
            open_project_ide(window, pane, proj)
            return
          end
        end
      end),
    },
  },

  -- SSH Domains
  { key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs { flags = "SSH_DOMAINS" } },

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

-- Copy/Paste (platform specific)
if IS_MACOS then
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
  table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
end

-- ── MOUSE ──────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  { event = { Down = { streak = 1, button = "Right" } }, mods = "NONE", action = act.PasteFrom("Clipboard") },
}

return config
