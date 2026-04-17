local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

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

-- ── PROJECT PROFILES (custom behavior per project) ────────────────────
local project_profiles = {
  ["infra"] = {
    stack = "docker",
    services = { "docker compose up" },
    logs = { "docker compose logs -f" },
  },

  ["api"] = {
    stack = "go",
    services = { "air || go run ." },
    logs = { "echo 'Go logs'" },
  },

  ["backend-rust"] = {
    stack = "rust",
    services = { "cargo watch -x run || cargo run" },
    logs = { "echo 'Rust logs'" },
  },
}

-- ── PROJECT SCANNER ──────────────────────────────────────────────────
local function scan_projects()
  local home = os.getenv("HOME")

  local stdout = wezterm.run_child_process({
    "bash",
    "-c",
    "find " .. home .. "/dev -maxdepth 1 -type d",
  })

  local projects = {}

  if stdout then
    for line in stdout:gmatch("[^\r\n]+") do
      local name = line:match(".*/(.*)")
      if name and name ~= "dev" then
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

  -- Switch workspace
  window:perform_action(
    act.SwitchToWorkspace {
      name = project.name,
      cwd = project.path,
    },
    pane
  )

  wezterm.sleep_ms(200)

  -- Editor (left)
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
      args = { "nvim" },
    },
    pane
  )

  wezterm.sleep_ms(200)

  -- Split right
  window:perform_action(
    act.SplitHorizontal { domain = "CurrentPaneDomain" },
    pane
  )

  wezterm.sleep_ms(200)

  -- Services (top-right)
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

  -- Logs (bottom-right)
  window:perform_action(
    act.SplitVertical { domain = "CurrentPaneDomain" },
    pane
  )

  wezterm.sleep_ms(200)

  if profile and profile.logs then
    run_commands(window, pane, profile.logs)
  else
    if stack == "docker" then
      run_commands(window, pane, { "docker compose logs -f" })
    else
      run_commands(window, pane, { "echo 'logs'" })
    end
  end

  -- Git UI (new tab)
  wezterm.sleep_ms(200)
  window:perform_action(
    act.SpawnTab {
      cwd = project.path,
      args = { "lazygit" },
    },
    pane
  )
end

-- ── FONT & RENDERING ─────────────────────────────────────────────────
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font("JetBrainsMono Nerd Font")

-- ── PERFORMANCE ──────────────────────────────────────────────────────
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true

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

-- ── SCROLLBACK ───────────────────────────────────────────────────────
config.scrollback_lines = 10000
config.max_fps = 120
config.cursor_blink_rate = 0

-- ── TAB BAR ──────────────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER KEY ───────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }
config.default_workspace = "main"

-- ── KEYBINDINGS ──────────────────────────────────────────────────────
config.keys = {

  -- Workspaces
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },
  { key = "W", mods = "LEADER|SHIFT", action = act.SwitchToWorkspace },
  { key = "N", mods = "LEADER|SHIFT", action = act.SwitchToWorkspace },

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
            label = "📁 " .. proj.name .. " → " .. proj.path,
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

  -- Pane splits
  { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Pane control
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Resize panes
  { key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Utilities
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
  { key = "s", mods = "LEADER", action = act.ShowLauncher },
}

-- ── MOUSE ────────────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

-- ── SSH ──────────────────────────────────────────────────────────────
config.ssh_domains = {
  {
    name = "rpi",
    remote_address = "192.168.1.110",
    username = "raspi",
    ssh_option = { identityfile = "~/.ssh/id_ed25519" },
  },
}

return config
