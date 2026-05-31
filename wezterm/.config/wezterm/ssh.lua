-- ssh.lua — SSH connection helpers
-- Usage in wezterm.lua:
--   require("ssh").apply(config, act)

local M = {}

M.hosts = {
	raspi = {
		label = "🍓 Raspberry Pi",
		user  = "borba",
		addr  = "192.168.1.101",
	},
}

function M.apply(config, act)
	-- SSH domain definitions — lets WezTerm open panes directly on remote hosts
	config.ssh_domains = {}
	for id, host in pairs(M.hosts) do
		table.insert(config.ssh_domains, {
			name                 = id,
			remote_address       = host.addr,
			username             = host.user,
			multiplexing         = "None", -- disable WezTerm mux on remote; use tmux if needed
		})
	end
end

-- Returns an InputSelector action to pick a host and open a remote tab
function M.connect_action(act, wezterm)
	local choices = {}
	for id, host in pairs(M.hosts) do
		table.insert(choices, { id = id, label = host.label .. "  " .. host.user .. "@" .. host.addr })
	end

	return act.InputSelector({
		title   = "SSH Connect",
		choices = choices,
		action  = wezterm.action_callback(function(window, pane, id)
			if not id then return end
			window:perform_action(
				act.SpawnCommandInNewTab({
					args = { "ssh", M.hosts[id].user .. "@" .. M.hosts[id].addr },
				}),
				pane
			)
		end),
	})
end

return M
