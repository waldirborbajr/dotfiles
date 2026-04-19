---@type vim.lsp.Config

return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
	root_markers = { ".git" },
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		yaml = {
			format = {
				enable = true,
			},
			validate = true,
			hover = true,
			completion = true,
		},
	},
}
