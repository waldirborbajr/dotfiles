-- ══════════════════════════════════════════════════════════════════════
--  WezTerm Configuration
-- ══════════════════════════════════════════════════════════════════════
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder and wezterm.config_builder() or {}
local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

-- ── APPEARANCE ────────────────────────────────────────────────────────

config.color_scheme = "nord"

-- Cursor: steady bar that follows the Nord fg/bg palette
config.default_cursor_style = "SteadyBar"
config.force_reverse_video_cursor = true

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = IS_MACOS and 13.5 or 11.5

-- Window chrome and padding
config.window_decorations = "NONE"
config.window_padding = { left = 3, right = 3, top = 0, bottom = 0 }

-- Dim inactive panes so the focused one is always visually clear
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.65 }

-- Background: Nord base color (#2e3440) at 95% opacity
config.background = {
	{
		source = { Color = "#2e3440" },
		width = "100%",
		height = "100%",
		opacity = 0.90,
	},
}

-- ── BEHAVIOR ──────────────────────────────────────────────────────────
config.initial_cols = 120
config.initial_rows = 40
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false
config.scrollback_lines = 10000
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ── TAB BAR (disabled — using workspaces instead) ─────────────────────

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false

-- ── SSH ───────────────────────────────────────────────────────────────

local ssh_hosts = {
	raspi = {
		label = "🍓 Raspberry Pi",
		user = "borba",
		addr = "192.168.1.101",
	},
}

-- Register SSH domains so WezTerm can open panes directly on remote hosts
config.ssh_domains = {}
for id, host in pairs(ssh_hosts) do
	table.insert(config.ssh_domains, {
		name = id,
		remote_address = host.addr,
		username = host.user,
		multiplexing = "None", -- disable WezTerm mux on remote; use tmux if needed
	})
end

-- Returns an InputSelector action to pick an SSH host and open it in a new tab
local function ssh_connect_action()
	local choices = {}
	for id, host in pairs(ssh_hosts) do
		table.insert(choices, {
			id = id,
			label = host.label .. "  " .. host.user .. "@" .. host.addr,
		})
	end

	return act.InputSelector({
		title = "SSH Connect",
		choices = choices,
		action = wezterm.action_callback(function(window, pane, id)
			if not id then
				return
			end
			window:perform_action(
				act.SpawnCommandInNewTab({
					args = { "ssh", ssh_hosts[id].user .. "@" .. ssh_hosts[id].addr },
				}),
				pane
			)
		end),
	})
end

-- ── PROJECTS ─────────────────────────────────────────────────────────

-- Scans ~/prj for top-level directories and returns them as project entries
local function scan_projects()
	local home = os.getenv("HOME")
	local dirs = { home .. "/prj" }
	local cmd = 'for d in "'
		.. table.concat(dirs, '" "')
		.. '"; do [ -d "$d" ] && find "$d" -mindepth 1 -maxdepth 1 -type d 2>/dev/null; done'
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

-- Switches to (or creates) a workspace named after the project
local function open_project(window, pane, project)
	window:perform_action(act.SwitchToWorkspace({ name = project.id, cwd = project.path }), pane)
end

-- ── KEYBINDINGS ───────────────────────────────────────────────────────
-- To avoid conflicts when running inside tmux, comment out the leader
-- definition and all LEADER bindings below.

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }

config.keys = {
	-- Always-active global binding
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },

	  { key = 'l', mods = 'ALT', action = act.ShowLauncherArgs {
      flags = 'FUZZY|TABS|DOMAINS|LAUNCH_MENU_ITEMS|WORKSPACES|COMMANDS' } },
	  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
	  { key = 'n', mods = 'LEADER', action = act.PromptInputLine {
	      description = 'New/switch workspace:',
	      action = wezterm.action_callback(function(window, pane, line)
	        if line and #line > 0 then
	          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
	        end
	      end) } },

	  { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	  { key = '-',  mods = 'LEADER', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
	  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
	  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
	  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
	  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
	  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
	  -- Pop the current tab/pane out into its own new window. WezTerm has no native
	  -- mouse drag-to-detach; this is the supported equivalent (pane:move_to_new_window).
	  { key = 'o', mods = 'LEADER', action = wezterm.action_callback(function(window, pane)
	      pane:move_to_new_window()
	  end) },
	  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },

	-- Workspaces / launcher
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
	{ key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },

	-- Resize panes (LEADER + hjkl)
	{ key = "h", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 6 }) },
	{ key = "j", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 6 }) },
	{ key = "k", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 6 }) },
	{ key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 6 }) },

	-- Resize panes reversed (LEADER + SHIFT + hjkl)
	{ key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 6 }) },
	{ key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 6 }) },
	{ key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 6 }) },
	{ key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 6 }) },

	-- Navigate panes (LEADER + CTRL + hjkl)
	{ key = "h", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER|CTRL", action = act.ActivatePaneDirection("Right") },

	-- Splits
	{ key = "v", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },
	{ key = "h", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },

	-- Tabs
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1) },

	-- Misc
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },

	-- Scrollback search: fuzzy-search through terminal history
	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
	-- Quick select: highlight URLs, hashes, IPs, paths for instant copy
	{ key = "q", mods = "LEADER", action = act.QuickSelect },
}

-- Copy / Paste (platform-aware)
if IS_MACOS then
	table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
else
	table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
end

-- Project launcher (LEADER+p)
table.insert(config.keys, {
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
			if not id then
				return
			end
			for _, p in ipairs(scan_projects()) do
				if p.id == id then
					open_project(window, pane, p)
					return
				end
			end
		end),
	}),
})

-- SSH host picker (LEADER+e) — opens remote session in a new tab
table.insert(config.keys, {
	key = "e",
	mods = "LEADER",
	action = ssh_connect_action(),
})

-- ── MOUSE BINDINGS ────────────────────────────────────────────────────

config.mouse_bindings = {
	-- Open hyperlinks with Cmd/Ctrl + left click
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = IS_MACOS and "CMD" or "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Right-click pastes from clipboard
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

-- ══════════════════════════════════════════════════════════════════════
return config
