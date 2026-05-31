-- keys.lua — WezTerm keyboard & mouse bindings
-- Separated so they can be conditionally included without clashing with tmux.
-- Usage in wezterm.lua:
--   require("keys").apply(config, IS_MACOS, act)

local M = {}

function M.apply(config, IS_MACOS, act)
	-- ── LEADER ──────────────────────────────────────────────────────────
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 800 }

	-- ── KEYBINDINGS ─────────────────────────────────────────────────────
	config.keys = {
		-- Project launcher (requires scan_projects / open_project from wezterm.lua)
		-- { key = "p", mods = "LEADER", action = ... }  -- wired up in wezterm.lua

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
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState               },
		{ key = "[", mods = "LEADER", action = act.ActivateCopyMode                  },
		{ key = "r", mods = "LEADER", action = act.ReloadConfiguration               },
		{ key = "s", mods = "LEADER", action = act.ShowLauncher                      },
		{ key = "S", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },
	}

	-- ── COPY / PASTE ────────────────────────────────────────────────────
	if IS_MACOS then
		table.insert(config.keys, { key = "v", mods = "CMD",        action = act.PasteFrom("Clipboard") })
		table.insert(config.keys, { key = "c", mods = "CMD",        action = act.CopyTo("Clipboard")    })
	else
		table.insert(config.keys, { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") })
		table.insert(config.keys, { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard")    })
	end

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
