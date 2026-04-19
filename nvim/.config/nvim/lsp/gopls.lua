---@type vim.lsp.Config

return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			analyses = { unusedparams = true, unreachable = true },
			staticcheck = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				constantValues = true,
				parameterNames = true,
				rangeVariableTypes = true,
				functionTypeParameters = true,
			},
		},
	},
}
