local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- ── PLATFORM ──────────────────────────────────────────────────────────────
local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

-- ── RENDER ────────────────────────────────────────────────────────────────
if IS_MACOS then
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "LowPower"
	config.max_fps = 60
	config.animation_fps = 30
	config.macos_window_background_blur = 0
else
	config.front_end = "OpenGL"
	config.max_fps = 60
	config.animation_fps = 30
end

-- ── FONT ──────────────────────────────────────────────────────────────────
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = IS_MACOS and 12 or 11
config.line_height = 1.2

-- performance
config.harfbuzz_features = { "calt=0", "liga=0", "clig=0" }
config.scrollback_lines = 5000
config.cursor_blink_rate = 0

-- ── UI ────────────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Macchiato"
config.window_decorations = "NONE"
config.window_padding = { left = 6, right = 6, top = 6, bottom = 16 }

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- ── LEADER ────────────────────────────────────────────────────────────────
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 600 }
config.window_close_confirmation = "NeverPrompt"

-- ── PROJECT SCAN ──────────────────────────────────────────────────────────
local function scan_projects()
	local home = os.getenv("HOME")
	local success, stdout = wezterm.run_child_process({
		"bash",
		"-c",
		"dir="
			.. home
			.. '/prj; [ -d "$dir" ] || dir='
			.. home
			.. "/dev; "
			.. 'find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null',
	})
	if not success or not stdout then
		return {}
	end

	local projects = {}
	for line in stdout:gmatch("[^\r\n]+") do
		local name = line:match(".*/(.*)")
		if name then
			table.insert(projects, { id = name, path = line })
		end
	end
	return projects
end

local projects = scan_projects()

-- ── OPEN PROJECT ──────────────────────────────────────────────────────────
local function open_project(window, pane, project)
	window:perform_action(act.SwitchToWorkspace({ name = project.id, cwd = project.path }), pane)
	window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
	window:perform_action(act.SendString("cd " .. project.path .. " && nvim\n"), pane)
	window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
	window:perform_action(act.SendString("cd " .. project.path .. "\n"), pane)
end

-- ── SSH ───────────────────────────────────────────────────────────────────
local ssh_hosts = wezterm.default_ssh_domains()
for _, dom in ipairs(ssh_hosts) do
	dom.assume_shell = "Posix"
	dom.local_echo_threshold_ms = 250
	dom.timeout = 120
end
config.ssh_domains = ssh_hosts

-- ── KEYBINDINGS ───────────────────────────────────────────────────────────
config.keys = {
	-- Projects
	{
		key = "p",
		mods = "LEADER",
		action = act.InputSelector({
			title = "🚀 Projects",
			choices = (function()
				local t = {}
				for _, p in ipairs(projects) do
					table.insert(t, { id = p.id, label = "📁 " .. p.id })
				end
				return t
			end)(),
			action = wezterm.action_callback(function(window, pane, id)
				if not id then
					return
				end
				for _, p in ipairs(projects) do
					if p.id == id then
						open_project(window, pane, p)
						return
					end
				end
			end),
		}),
	},

	-- Fullscreen / Maximize
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },

	-- Resize (estilo Zellij)
	-- Leader + hjkl        → Aumentar pane
	-- Leader + Shift + hjkl → Diminuir pane
	{ key = "h", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

	{ key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },

	-- SSH / Domains
	{ key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },

	-- Tabs
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },

	-- Splits
	{ key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Navegação de Panes (Ctrl para não conflitar com resize)
	{ key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

	-- Zoom
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Utils
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
}

-- ── COPY / PASTE ──────────────────────────────────────────────────────────
if IS_MACOS then
	table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
	table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
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
