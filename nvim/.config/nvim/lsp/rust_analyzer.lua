---@type vim.lsp.Config

return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				runBuildScripts = true,
			},
			checkOnSave = true,
			checkOnSaveCommand = "clippy",
			procMacro = { enable = true },
			files = { exclude = { "target/**" } },
			formatting = { enable = true },
			inlayHints = {
				enable = true,
				bindingModeHints = { enable = false },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				closureReturnTypeHints = { enable = "never" },
				lifetimeElisionHints = { enable = "never", useParameterNames = false },
				maxLength = 25,
				parameterHints = { enable = true },
				reborrowHints = { enable = "never" },
				renderColons = true,
				typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
			},
		},
	},
}
