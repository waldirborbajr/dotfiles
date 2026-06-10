-- ══════════════════════════════════════════════════════════════════════
--  WezTerm Configuration
--  Nord theme — Linux x86_64 + macOS Apple Silicon (M2)
-- ══════════════════════════════════════════════════════════════════════
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder and wezterm.config_builder() or {}
local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

-- ── APPEARANCE ────────────────────────────────────────────────────────

config.color_scheme = "nord"
config.default_cursor_style = "SteadyBar"
config.force_reverse_video_cursor = true

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = IS_MACOS and 13.5 or 11.5

config.window_decorations = IS_MACOS and "RESIZE" or "NONE"
config.window_padding = { left = 6, right = 6, top = 4, bottom = 4 }

-- Dim inactive panes
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.65 }

config.background = {
	{
		source = { Color = "#2e3440" },
		width = "100%",
		height = "100%",
		opacity = 1.0,
	},
}

-- ── BEHAVIOR ──────────────────────────────────────────────────────────

config.initial_cols = 120
config.initial_rows = 40
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.check_for_updates = false
config.scrollback_lines = 12000
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Faster key repeat (useful in nvim/helix)
config.key_map_preference = "Mapped"

-- ── TAB BAR ───────────────────────────────────────────────────────────

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.enable_tab_bar = true -- enabled: useful with multiple tabs/workspaces
config.hide_tab_bar_if_only_one_tab = true -- hidden when only one tab — clean look

config.colors = {
	tab_bar = {
		background = "#2e3440",
		active_tab = { bg_color = "#4c566a", fg_color = "#eceff4", intensity = "Bold" },
		inactive_tab = { bg_color = "#2e3440", fg_color = "#7b8394" },
		inactive_tab_hover = { bg_color = "#3b4252", fg_color = "#d8dee9" },
		new_tab = { bg_color = "#2e3440", fg_color = "#4c566a" },
		new_tab_hover = { bg_color = "#3b4252", fg_color = "#88c0d0" },
	},
}

-- ── SSH ───────────────────────────────────────────────────────────────

local ssh_hosts = {
	raspi = {
		label = "🍓 Raspberry Pi",
		user = "borba",
		addr = "192.168.1.101",
	},
}

config.ssh_domains = {}
for id, host in pairs(ssh_hosts) do
	table.insert(config.ssh_domains, {
		name = id,
		remote_address = host.addr,
		username = host.user,
		multiplexing = "None",
	})
end

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

-- ── PROJECTS ──────────────────────────────────────────────────────────
-- Scans $HOME/prj for top-level directories.
-- Results cached per config load — scan_projects() called once at startup,
-- not on every keypress.

local _projects_cache = nil

local function scan_projects()
	if _projects_cache then
		return _projects_cache
	end
	local home = os.getenv("HOME")
	local base = home .. "/prj"
	local _, stdout = wezterm.run_child_process({
		"find",
		base,
		"-mindepth",
		"1",
		"-maxdepth",
		"1",
		"-type",
		"d",
	})
	local projects = {}
	if stdout then
		for line in stdout:gmatch("[^\r\n]+") do
			local name = line:match(".*/(.+)$")
			if name then
				table.insert(projects, { id = name, label = "📁 " .. name, path = line })
			end
		end
		table.sort(projects, function(a, b)
			return a.id < b.id
		end)
	end
	_projects_cache = projects
	return projects
end

local function project_launcher()
	local projects = scan_projects()
	local choices = {}
	for _, p in ipairs(projects) do
		table.insert(choices, { id = p.id, label = p.label })
	end
	return act.InputSelector({
		title = "🚀 Open Project",
		choices = choices,
		action = wezterm.action_callback(function(window, pane, id)
			if not id then
				return
			end
			for _, p in ipairs(projects) do -- projects already in scope — no second scan
				if p.id == id then
					window:perform_action(act.SwitchToWorkspace({ name = p.id, spawn = { cwd = p.path } }), pane)
					return
				end
			end
		end),
	})
end

-- ── KEYBINDINGS ───────────────────────────────────────────────────────
-- Convention:
--   LEADER+hjkl         → navigate panes
--   LEADER+SHIFT+hjkl   → resize panes
--   LEADER+\            → split vertical (new pane to the right)
--   LEADER+-            → split horizontal (new pane below)
--   LEADER+n            → new/switch workspace by name
--   LEADER+t            → new tab
--   LEADER+a            → removed (was Ctrl+A passthrough; tmux uses Ctrl+B)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }

config.keys = {

	-- ── Global (no leader) ──────────────────────────────────────────
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	{
		key = "l",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|TABS|DOMAINS|LAUNCH_MENU_ITEMS|WORKSPACES|COMMANDS",
		}),
	},

	-- ── Splits ──────────────────────────────────────────────────────
	-- \ = vertical split (new pane to the right)
	{ key = "\\", mods = "LEADER", action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
	-- -  = horizontal split (new pane below)
	{ key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down", size = { Percent = 40 } }) },

	-- ── Pane navigation (LEADER+hjkl) ───────────────────────────────
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- ── Pane resize (LEADER+SHIFT+hjkl) ─────────────────────────────
	{ key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 6 }) },
	{ key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 6 }) },
	{ key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 6 }) },
	{ key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 6 }) },

	-- ── Pane misc ───────────────────────────────────────────────────
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action_callback(function(_, pane)
			pane:move_to_new_window()
		end),
	},

	-- ── Tabs (LEADER+t / LEADER+x / LEADER+[ / LEADER+]) ───────────
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },

	-- ── Workspaces ──────────────────────────────────────────────────
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "n",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "New/switch workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line and #line > 0 then
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{ key = "p", mods = "LEADER", action = project_launcher() },

	-- ── SSH ─────────────────────────────────────────────────────────
	{ key = "e", mods = "LEADER", action = ssh_connect_action() },

	-- ── Misc ────────────────────────────────────────────────────────
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "m", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
	{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
	{ key = "q", mods = "LEADER", action = act.QuickSelect },
	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
}

-- Copy/Paste — platform-aware
if IS_MACOS then
	table.insert(config.keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
	table.insert(config.keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "=", mods = "CMD", action = act.IncreaseFontSize })
	table.insert(config.keys, { key = "-", mods = "CMD", action = act.DecreaseFontSize })
	table.insert(config.keys, { key = "0", mods = "CMD", action = act.ResetFontSize })
else
	table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") })
	table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "=", mods = "CTRL", action = act.IncreaseFontSize })
	table.insert(config.keys, { key = "-", mods = "CTRL", action = act.DecreaseFontSize })
	table.insert(config.keys, { key = "0", mods = "CTRL", action = act.ResetFontSize })
end

-- ── MOUSE BINDINGS ────────────────────────────────────────────────────

config.mouse_bindings = {
	-- Cmd/Ctrl + left click → open hyperlink
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = IS_MACOS and "CMD" or "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Right-click → paste
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
}

-- ══════════════════════════════════════════════════════════════════════
return config
