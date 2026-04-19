return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		local keymaps = require("config.keymaps")

		require("Comment").setup({
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
		})
	end,
}
