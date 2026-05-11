-- local wezterm = require("wezterm")
-- local act = wezterm.action
-- local config = {}

-- -- ── PLATFORM ──────────────────────────────────────────────────────────────
-- local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

-- -- ── RENDER ────────────────────────────────────────────────────────────────
-- if IS_MACOS then
-- 	config.front_end = "WebGpu"
-- 	config.webgpu_power_preference = "LowPower"
-- 	config.max_fps = 60
-- 	config.animation_fps = 30
-- 	config.macos_window_background_blur = 0
-- else
-- 	config.front_end = "OpenGL"
-- 	config.max_fps = 60
-- 	config.animation_fps = 30
-- end

-- -- ── FONT ──────────────────────────────────────────────────────────────────
-- config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font_size = IS_MACOS and 14 or 12
-- config.line_height = 1.2

-- -- performance
-- config.harfbuzz_features = { "calt=0", "liga=0", "clig=0" }
-- config.scrollback_lines = 5000
-- config.cursor_blink_rate = 0

-- -- ── UI ────────────────────────────────────────────────────────────────────
-- config.color_scheme = "Catppuccin Macchiato"
-- config.window_decorations = "NONE"
-- config.window_padding = { left = 6, right = 6, top = 6, bottom = 16 }

-- config.enable_tab_bar = true
-- config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

-- -- ── LEADER ────────────────────────────────────────────────────────────────
-- config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 }
-- config.window_close_confirmation = "NeverPrompt"

-- -- ── PROJECT SCAN ──────────────────────────────────────────────────────────
-- local function scan_projects()
-- 	local home = os.getenv("HOME")
-- 	local success, stdout = wezterm.run_child_process({
-- 		"bash",
-- 		"-c",
-- 		"dir="
-- 			.. home
-- 			.. '/prj; [ -d "$dir" ] || dir='
-- 			.. home
-- 			.. "/dev; "
-- 			.. 'find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null',
-- 	})
-- 	if not success or not stdout then
-- 		return {}
-- 	end

-- 	local projects = {}
-- 	for line in stdout:gmatch("[^\r\n]+") do
-- 		local name = line:match(".*/(.*)")
-- 		if name then
-- 			table.insert(projects, { id = name, path = line })
-- 		end
-- 	end
-- 	return projects
-- end

-- local projects = scan_projects()

-- -- ── OPEN PROJECT ──────────────────────────────────────────────────────────
-- local function open_project(window, pane, project)
-- 	window:perform_action(act.SwitchToWorkspace({ name = project.id, cwd = project.path }), pane)
-- 	window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
-- 	window:perform_action(act.SendString("cd " .. project.path .. " && nvim\n"), pane)
-- 	window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
-- 	window:perform_action(act.SendString("cd " .. project.path .. "\n"), pane)
-- end

-- -- ── SSH ───────────────────────────────────────────────────────────────────
-- local ssh_hosts = wezterm.default_ssh_domains()
-- for _, dom in ipairs(ssh_hosts) do
-- 	dom.assume_shell = "Posix"
-- 	dom.local_echo_threshold_ms = 250
-- 	dom.timeout = 120
-- end
-- config.ssh_domains = ssh_hosts

-- -- ── KEYBINDINGS ───────────────────────────────────────────────────────────
-- config.keys = {
-- 	-- Projects
-- 	{
-- 		key = "p",
-- 		mods = "LEADER",
-- 		action = act.InputSelector({
-- 			title = "🚀 Projects",
-- 			choices = (function()
-- 				local t = {}
-- 				for _, p in ipairs(projects) do
-- 					table.insert(t, { id = p.id, label = "📁 " .. p.id })
-- 				end
-- 				return t
-- 			end)(),
-- 			action = wezterm.action_callback(function(window, pane, id)
-- 				if not id then
-- 					return
-- 				end
-- 				for _, p in ipairs(projects) do
-- 					if p.id == id then
-- 						open_project(window, pane, p)
-- 						return
-- 					end
-- 				end
-- 			end),
-- 		}),
-- 	},

-- 	-- Fullscreen / Maximize
-- 	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },

-- 	-- Resize (estilo Zellij)
-- 	-- Leader + hjkl        → Aumentar pane
-- 	-- Leader + Shift + hjkl → Diminuir pane
-- 	{ key = "h", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
-- 	{ key = "j", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
-- 	{ key = "k", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
-- 	{ key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

-- 	{ key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
-- 	{ key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
-- 	{ key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
-- 	{ key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },

-- 	-- SSH / Domains
-- 	{ key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },

-- 	-- Tabs
-- 	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
-- 	{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
-- 	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
-- 	{ key = "p", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },

-- 	-- Splits
-- 	{ key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
-- 	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

-- 	-- Navegação de Panes (Ctrl para não conflitar com resize)
-- 	{ key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
-- 	{ key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
-- 	{ key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
-- 	{ key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

-- 	-- Zoom
-- 	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

-- 	-- Utils
-- 	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
-- 	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
-- 	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
-- }

-- -- ── COPY / PASTE ──────────────────────────────────────────────────────────
-- if IS_MACOS then
-- 	table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
-- 	table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
-- else
-- 	table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
-- 	table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
-- end

-- -- ── MOUSE ─────────────────────────────────────────────────────────────────
-- config.mouse_bindings = {
-- 	{
-- 		event = { Down = { streak = 1, button = "Right" } },
-- 		mods = "NONE",
-- 		action = act.PasteFrom("Clipboard"),
-- 	},
-- }

-- return config

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

-- ====================== EDITOR PREFERENCE ======================
local function get_editor()
  -- Prioriza Helix (hx), fallback para nvim
  local success, stdout = wezterm.run_child_process({ "which", "hx" })
  if success and stdout and stdout:match("hx") then
    return "hx"
  end
  return "nvim"
end

local EDITOR = get_editor()
local EDITOR_CMD = EDITOR == "hx" and "hx" or "nvim"

-- ── RENDER & PERFORMANCE ───────────────────────────────────────────────
if IS_MACOS then
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "LowPower"
  config.macos_window_background_blur = 20
else
  config.front_end = "OpenGL"
end

config.max_fps = 120
config.animation_fps = 60

-- ── FONT ───────────────────────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = IS_MACOS and 13 or 12
config.line_height = 1.1
config.harfbuzz_features = { "calt=0", "liga=0", "clig=0" }

config.scrollback_lines = 10000
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"

-- ── UI ────────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "NONE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 12 }

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32

config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.65,
}

-- ── LEADER ────────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }
config.window_close_confirmation = "NeverPrompt"

-- ── HYPERLINK RULES ───────────────────────────────────────────────────
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[\b[A-Z]{2,10}-\d{3,8}\b]],           -- Jira tickets
  format = "https://yourcompany.atlassian.net/browse/$0",
})

table.insert(config.hyperlink_rules, {
  regex = [[#(\d+)]],                            -- GitHub PRs/Issues
  format = "https://github.com/YOUR_ORG/YOUR_REPO/pull/$1", -- ← altere aqui
})

table.insert(config.hyperlink_rules, {
  regex = [[\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?\b]],
  format = "http://$0",
})

-- ── BELL NOTIFICATION ─────────────────────────────────────────────────
config.audible_bell = "SystemBeep"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_out_function = "EaseOut",
  fade_in_duration_ms = 150,
  fade_out_duration_ms = 300,
}

wezterm.on("bell", function(window, pane)
  if not window:is_focused() then
    window:toast_notification(
      "WezTerm",
      "✓ Comando finalizado",
      nil,
      5000
    )
  end
end)

-- ── STATUS BAR ────────────────────────────────────────────────────────
wezterm.on("update-status", function(window, _)
  local workspace = window:active_workspace()
  local hostname = wezterm.hostname():match("^[^.]+")
  local date = wezterm.strftime("%H:%M")

  local battery = ""
  if IS_MACOS then
    for _, b in ipairs(wezterm.battery_info()) do
      local icon = b.state == "Charging" and "󰂄" or "󰁹"
      battery = string.format(" %s %.0f%%", icon, b.state_of_charge * 100)
      break
    end
  end

  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#a6adc8" } },
    { Text = workspace .. "   " },
    { Foreground = { Color = "#9399b2" } },
    { Text = hostname .. "   " },
    { Foreground = { Color = "#cba6f7" } },
    { Text = date },
    { Foreground = { Color = "#a6e3a1" } },
    { Text = battery },
  }))
end)

-- ── DYNAMIC TAB TITLE ─────────────────────────────────────────────────
wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local pane = tab.active_pane
  local proc = pane.foreground_process_name:match("([^/]+)$") or ""

  if proc == "hx" or proc == "nvim" then
    local dir = pane.title:match("([^/]+)$") or "editor"
    return { { Text = " " .. (proc == "hx" and "" or "") .. " " .. dir .. " " } }
  end

  if proc ~= "" and not proc:match("zsh|bash|fish|sh") then
    return { { Text = " " .. proc .. " " } }
  end

  local cwd = pane.current_working_dir
  if cwd then
    local dir = cwd.file_path:match("([^/]+)/?$") or cwd.file_path
    return { { Text = " " .. dir .. " " } }
  end

  return { { Text = " " .. (pane.title or "terminal") .. " " } }
end)

-- ── PROJECTS ──────────────────────────────────────────────────────────
local function scan_projects()
  local home = os.getenv("HOME")
  local dirs = { home .. "/prj", home .. "/dev", home .. "/projects" }

  local cmd = 'for d in "' .. table.concat(dirs, '" "') .. '"; do [ -d "$d" ] && find "$d" -mindepth 1 -maxdepth 1 -type d 2>/dev/null; done'

  local _, stdout = wezterm.run_child_process({ "bash", "-c", cmd })
  local projects = {}

  if stdout then
    for line in stdout:gmatch("[^\r\n]+") do
      local name = line:match(".*/(.*)")
      if name then
        table.insert(projects, { id = name, path = line })
      end
    end
  end
  return projects
end

-- ── OPEN PROJECT COM LAYOUT FIXO ───────────────────────────────────────
local function open_project(window, pane, project)
  window:perform_action(
    act.SwitchToWorkspace({ name = project.id, cwd = project.path }),
    pane
  )

  wezterm.time.call_after(0.2, function()
    -- Editor principal (Helix ou Neovim) à esquerda
    window:perform_action(
      act.SendString("cd " .. project.path .. " && " .. EDITOR_CMD .. "\n"),
      pane
    )

    -- Split vertical (terminal direito)
    window:perform_action(act.SplitPane({
      direction = "Right",
      size = { Percent = 45 },
      cwd = project.path,
    }), pane)

    -- Split horizontal no painel direito (terminal inferior)
    window:perform_action(act.SplitPane({
      direction = "Down",
      size = { Percent = 40 },
      cwd = project.path,
    }), pane)

    -- Foca novamente no editor
    window:perform_action(act.ActivatePaneDirection("Left"), pane)
  end)
end

-- ── KEYBINDINGS ───────────────────────────────────────────────────────
config.keys = {
  {
    key = "p",
    mods = "LEADER",
    action = act.InputSelector({
      title = "🚀 Open Project",
      choices = (function()
        local t = {}
        for _, p in ipairs(scan_projects()) do
          table.insert(t, { id = p.id, label = "📁 " .. p.id })
        end
        return t
      end)(),
      action = wezterm.action_callback(function(window, pane, id)
        if not id then return end
        for _, p in ipairs(scan_projects()) do
          if p.id == id then
            open_project(window, pane, p)
            return
          end
        end
      end),
    }),
  },

  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
  { key = "f", mods = "LEADER", action = act.ToggleFullScreen },

  -- Resize Panes
  { key = "h", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 6 }) },
  { key = "j", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 6 }) },
  { key = "k", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 6 }) },
  { key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 6 }) },

  { key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 6 }) },
  { key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 6 }) },
  { key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 6 }) },
  { key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 6 }) },

  -- Navigation
  { key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

  -- Splits
  { key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Tabs
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },

  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
  { key = "s", mods = "LEADER", action = act.ShowLauncher },
  { key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },
}

-- Copy / Paste
if IS_MACOS then
  table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
  table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
  table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
end

-- Mouse Bindings
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = IS_MACOS and "CMD" or "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

return config
