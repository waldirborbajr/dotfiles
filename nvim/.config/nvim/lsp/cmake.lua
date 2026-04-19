---@type vim.lsp.Config
return {
	cmd = { "cmake-language-server" },
	filetypes = { "cmake" },
	init_optios = {
		buildDirectory = "build",
	},
	root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
}
