---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	capabilities = {
		offsetEncoding = { "utf-8", "utf-16" },
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
	},
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
}
