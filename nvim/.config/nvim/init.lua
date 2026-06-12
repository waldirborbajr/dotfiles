-- vim ui2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd", -- options: cmd(classic), msg(similar to noice)
		pager = { height = 1 },
		msg = { height = 0.5, timeout = 4500 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
	},
})

vim.pack.add{ "https://github.com/neovim/nvim-lspconfig" }
vim.lsp.enable("gopls")
vim.cmd.colorscheme("catppuccin")
