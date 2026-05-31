-- keys.lua — WezTerm keyboard & mouse bindings
-- Separated so they can be conditionally included without clashing with tmux.
-- Usage in wezterm.lua:
--   require("keys").apply(config, IS_MACOS, act, wezterm, scan_projects, open_project)
--
-- Uses table.insert throughout to preserve any bindings already in config.keys
-- (e.g. the F11 fullscreen key defined unconditionally in wezterm.lua).

local M = {}

function M.apply(config, IS_MACOS, act, wezterm, scan_projects, open_project)
	-- ── LEADER ──────────────────────────────────────────────────────────
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }

	-- ── KEYBINDINGS ─────────────────────────────────────────────────────
	-- Appends to config.keys so existing entries (e.g. F11) are preserved.
	local bindings = {
		{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
		{ key = "f", mods = "LEADER", action = act.ToggleFullScreen },

		-- Resize panes
		{ key = "h", mods = "LEADER",       action = act.AdjustPaneSize({ "Left",  6 }) },
		{ key = "j", mods = "LEADER",       action = act.AdjustPaneSize({ "Down",  6 }) },
		{ key = "k", mods = "LEADER",       action = act.AdjustPaneSize({ "Up",    6 }) },
		{ key = "l", mods = "LEADER",       action = act.AdjustPaneSize({ "Right", 6 }) },

		{ key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 6 }) },
		{ key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up",    6 }) },
		{ key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down",  6 }) },
		{ key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left",  6 }) },

		-- Navigate panes
		{ key = "h", mods = "LEADER|CTRL",  action = act.ActivatePaneDirection("Left")  },
		{ key = "j", mods = "LEADER|CTRL",  action = act.ActivatePaneDirection("Down")  },
		{ key = "k", mods = "LEADER|CTRL",  action = act.ActivatePaneDirection("Up")    },
		{ key = "l", mods = "LEADER|CTRL",  action = act.ActivatePaneDirection("Right") },

		-- Splits
		{ key = "v", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },
		{ key = "h", mods = "LEADER", action = act.SplitPane({ direction = "Down"  }) },

		-- Tabs
		{ key = "c", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain")       },
		{ key = "x", mods = "LEADER",       action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "n", mods = "LEADER",       action = act.ActivateTabRelative(1)               },
		{ key = "p", mods = "LEADER|SHIFT", action = act.ActivateTabRelative(-1)              },

		-- Misc
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState                          },
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode                             },
		{ key = "r", mods = "LEADER", action = act.ReloadConfiguration                          },
		{ key = "s", mods = "LEADER", action = act.ShowLauncher                                 },
		{ key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },

		-- ── HIGH VALUE ────────────────────────────────────────────────────
		-- Scrollback search: fuzzy search through terminal history
		{ key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
		-- Quick select: highlight URLs, hashes, IPs, paths for instant copy
		{ key = "q", mods = "LEADER", action = act.QuickSelect },
	}
	for _, b in ipairs(bindings) do
		table.insert(config.keys, b)
	end

	-- ── COPY / PASTE ────────────────────────────────────────────────────
	if IS_MACOS then
		table.insert(config.keys, { key = "v", mods = "CMD",        action = act.PasteFrom("Clipboard") })
		table.insert(config.keys, { key = "c", mods = "CMD",        action = act.CopyTo("Clipboard")    })
	else
		table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
		table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard")    })
	end

	-- ── PROJECT LAUNCHER ────────────────────────────────────────────────
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
				if not id then return end
				for _, p in ipairs(scan_projects()) do
					if p.id == id then
						open_project(window, pane, p)
						return
					end
				end
			end),
		}),
	})

	-- ── MOUSE BINDINGS ──────────────────────────────────────────────────
	config.mouse_bindings = {
		{
			event  = { Up = { streak = 1, button = "Left" } },
			mods   = IS_MACOS and "CMD" or "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
		{
			event  = { Down = { streak = 1, button = "Right" } },
			mods   = "NONE",
			action = act.PasteFrom("Clipboard"),
		},
	}
end

return M
