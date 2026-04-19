return {
	"saghen/blink.cmp",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"moyiz/blink-emoji.nvim",
	},
	version = "1.*",
	opts = {
		keymap = {
			preset = "enter",
			["<C-a>"] = {
				function(cmp)
					if cmp.is_visible() then
						cmp.hide()
					else
						cmp.show()
					end
				end,
			},
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-n>"] = { "show", "show_documentation", "hide_documentation" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = true },
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert_on_trigger_character = false,
				show_on_accept_on_trigger_character = false,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			ghost_text = { enabled = false },
		},
		signature = {
			enabled = false,
		},
		sources = {
			default = { "lsp", "path", "snippets", "emoji" },
			providers = {
				lsp = {
					score_offset = 1000,
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = { insert = true }, -- Insert emoji (default) or complete its name
				},
			},
		},
		fuzzy = {
			implementation = "prefer_rust",
		},
	},
	opts_extend = { "sources.default" },
}
