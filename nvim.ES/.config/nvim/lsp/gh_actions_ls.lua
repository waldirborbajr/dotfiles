---@type vim.lsp.Config
return {
	cmd = { "gh-actions-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	capabilities = {
		workspace = {
			didChangeWorkspaceFolders = {
				dynamicRegistration = true,
			},
		},
	},
	handlers = {
		["actions/readFile"] = function(_, params, callback)
			local uri = params.uri
			local path = vim.uri_to_fname(uri)

			local f = io.open(path, "r")
			if not f then
				callback(nil)
				return
			end

			local content = f:read("*a")
			f:close()

			callback(nil, content)
		end,
	},
}
