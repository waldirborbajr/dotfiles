-- WezTerm Main Configuration Entry Point
local wezterm = require("wezterm")
local act = wezterm.action
local config = require("config")
require("events")

config.color_scheme = "nord"

-- ── GLOBAL KEYBINDINGS (always active, even without keys.lua) ────────
config.keys = {
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
}

-- ── KEYBINDINGS ───────────────────────────────────────────────────────
-- Comment these two lines out when running inside tmux
-- so the LEADER and all bindings don't conflict with tmux's own prefix.
local IS_MACOS = wezterm.target_triple:find("apple") ~= nil

local function scan_projects()
	local home = os.getenv("HOME")
	local dirs = { home .. "/prj" }
	local cmd = 'for d in "' .. table.concat(dirs, '" "') .. '"; do [ -d "$d" ] && find "$d" -mindepth 1 -maxdepth 1 -type d 2>/dev/null; done'
	local _, stdout = wezterm.run_child_process({ "bash", "-c", cmd })
	local projects = {}
	if stdout then
		for line in stdout:gmatch("[^\r\n]+") do
			local name = line:match(".*/(.*)")
			if name then table.insert(projects, { id = name, path = line }) end
		end
	end
	return projects
end

local function open_project(window, pane, project)
	window:perform_action(act.SwitchToWorkspace({ name = project.id, cwd = project.path }), pane)
end

local keys = require("keys")
keys.apply(config, IS_MACOS, act, wezterm, scan_projects, open_project)

-- ── SSH ───────────────────────────────────────────────────────────────
local ssh = require("ssh")
ssh.apply(config, act)

-- LEADER+e → SSH host picker (opens remote session in a new tab)
table.insert(config.keys, {
	key = "e",
	mods = "LEADER",
	action = ssh.connect_action(act, wezterm),
})

return config
