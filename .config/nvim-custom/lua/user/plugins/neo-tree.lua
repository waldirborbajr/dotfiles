return {
	'nvim-neo-tree/neo-tree.nvim',
  cmd="Neotree",
	branch = 'v2.x',
  keys={
    {"<leader>e","<cmd>Neotree toggle<cr>", desc="Neotree"},
  },
	dependencies = {
		'MunifTanjim/nui.nvim',
	},
	config = function()
		require('neo-tree').setup({
			window = {
				width = 35,
			},
			filesystem = {
				filtered_items = {
					hide_gitignored = true,
					hide_dotfiles = false,
					hide_by_name = {
						'.gitignore',
						'.git',
						'.husky',
						'.swc',
					},
				},
				follow_current_file = false,
			},
		})
	end,
}
