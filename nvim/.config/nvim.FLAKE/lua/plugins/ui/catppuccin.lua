vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/tadaa/vimade", name = "vimade" },
})

require("catppuccin").setup({
	transparent_background = true, -- disables setting the background color.
	float = {
		transparent = true, -- enable transparent floating windows
		solid = false, -- use solid styling for floating windows, see |winborder|
	},
	show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
})

require("vimade").setup({
	recipe = { "minimalist", { animate = true } },
	fadelevel = 0.6,
})
