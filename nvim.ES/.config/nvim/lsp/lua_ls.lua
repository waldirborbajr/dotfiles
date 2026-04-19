---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".emmyrc.json",
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			telemetry = { enable = false },
			workspace = {
				checkThirdParty = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
			codeLens = {
				enable = true,
			},
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "All",
				semicolon = "All",
				arrayIndex = "All",
			},
		},
	},
}
