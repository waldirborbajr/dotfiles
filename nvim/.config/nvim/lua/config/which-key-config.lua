local wk = require("which-key")

wk.setup({
	preset = "helix",
	delay = 200,
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
})

wk.add({
	-- Leader mappings
	-- { "<leader>e", ":Neotree toggle<CR>", desc = "Explorer" },
	-- { "<leader><space>", ":Telescope find_files<CR>", desc = "Find Files" },
	-- { "<leader>t", "<cmd>lua _toggle_terminal()<CR>", desc = "Terminal" },
	-- { "<leader>T", "<cmd>lua _close_terminal_completely()<CR>", desc = "Kill Terminal" },
	
	-- Search group
	-- {
	-- 	"<leader>s",
	-- 	group = "Search",
	-- 	{ "<leader>sf", ":Telescope find_files<CR>", desc = "Find Files" },
	-- 	{ "<leader>sg", ":Telescope live_grep<CR>", desc = "Grep" },
	-- 	{ "<leader>sb", ":Telescope buffers<CR>", desc = "Buffers" },
	-- 	{ "<leader>sh", ":Telescope help_tags<CR>", desc = "Help" },
	-- },
	
	-- File group
	-- {
	-- 	"<leader>f",
	-- 	group = "File",
	-- 	{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find" },
	-- 	{ "<leader>fr", ":Telescope oldfiles<CR>", desc = "Recent" },
	-- 	{ "<leader>fn", ":enew<CR>", desc = "New" },
	-- },
	
	-- Workspace/project group
	{
		"<leader>w",
		group = "Workspace",
		{ "<leader>wf", ":Oil<CR>", desc = "Oil File Manager" },
		{ "<leader>wt", "<cmd>lua _toggle_terminal()<CR>", desc = "Toggle Terminal" },
		{ "<leader>wT", "<cmd>lua _close_terminal_completely()<CR>", desc = "Kill Terminal" },
	},
	
	-- Git group
	{
		"<leader>g",
		group = "Git",
		{ "<leader>go", ":DiffviewOpen<CR>", desc = "Open Diff" },
		{ "<leader>gc", ":DiffviewClose<CR>", desc = "Close Diff" },
	},
	
	-- LSP main group
	{
		"<leader>l",
		group = "LSP",
	},
	
	-- LSP Navigation group
	{
		"<leader>ln",
		group = "Navigate",
		{ "<leader>lnd", vim.lsp.buf.definition, desc = "Definition" },
		{ "<leader>lnD", vim.lsp.buf.declaration, desc = "Declaration" },
		{ "<leader>lni", vim.lsp.buf.implementation, desc = "Implementation" },
		{ "<leader>lnr", vim.lsp.buf.references, desc = "References" },
		{ "<leader>lnt", vim.lsp.buf.type_definition, desc = "Type Definition" },
	},
	
	-- LSP Refactor group
	{
		"<leader>lr",
		group = "Refactor",
		{ "<leader>lrn", vim.lsp.buf.rename, desc = "Rename Symbol" },
		{ "<leader>lra", vim.lsp.buf.code_action, desc = "Code Action" },
		{ "<leader>lrf", function()
			vim.lsp.buf.format({ async = true })
		end, desc = "Format Buffer" },
	},
	
	-- LSP Imports group
	{
		"<leader>li",
		group = "Imports",
		{ "<leader>lio", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.organizeImports" }
				},
				apply = true
			})
		end, desc = "Organize Imports" },
		{ "<leader>liu", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.removeUnused" }
				},
				apply = true
			})
		end, desc = "Remove Unused" },
		{ "<leader>lim", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.addMissingImports" }
				},
				apply = true
			})
		end, desc = "Add Missing Imports" },
	},
	
	-- LSP Symbols/Outline group
	{
		"<leader>ls",
		group = "Symbols",
		{ "<leader>lsd", function()
			if package.loaded['snacks'] then
				Snacks.picker.lsp_symbols()
			else
				vim.lsp.buf.document_symbol()
			end
		end, desc = "Document Symbols" },
		{ "<leader>lsw", function()
			if package.loaded['snacks'] then
				Snacks.picker.lsp_workspace_symbols()
			else
				vim.lsp.buf.workspace_symbol()
			end
		end, desc = "Workspace Symbols" },
	},
	
	-- LSP Calls group
	{
		"<leader>lc",
		group = "Calls",
		{ "<leader>lci", function()
			if package.loaded['snacks'] then
				Snacks.picker.lsp_incoming_calls()
			else
				vim.lsp.buf.incoming_calls()
			end
		end, desc = "Incoming Calls" },
		{ "<leader>lco", function()
			if package.loaded['snacks'] then
				Snacks.picker.lsp_outgoing_calls()
			else
				vim.lsp.buf.outgoing_calls()
			end
		end, desc = "Outgoing Calls" },
	},
	
	-- LSP Diagnostics group
	{
		"<leader>ld",
		group = "Diagnostics",
		{ "<leader>ldo", vim.diagnostic.open_float, desc = "Open Float" },
		{ "<leader>ldp", vim.diagnostic.goto_prev, desc = "Previous" },
		{ "<leader>ldn", vim.diagnostic.goto_next, desc = "Next" },
		{ "<leader>lda", function()
			if package.loaded['snacks'] then
				Snacks.picker.diagnostics()
			else
				vim.diagnostic.setloclist()
			end
		end, desc = "All Diagnostics" },
		{ "<leader>ldb", function()
			if package.loaded['snacks'] then
				Snacks.picker.diagnostics_buffer()
			else
				vim.diagnostic.setqflist()
			end
		end, desc = "Buffer Diagnostics" },
	},
	
	-- LSP Help group
	{
		"<leader>lh",
		group = "Help",
		{ "<leader>lhh", vim.lsp.buf.hover, desc = "Hover Info" },
		{ "<leader>lhs", vim.lsp.buf.signature_help, desc = "Signature Help" },
	},
	
	-- Quit group
	{
		"<leader>q",
		group = "Quit",
		{ "<leader>qq", ":qa<CR>", desc = "Quit All" },
		{ "<leader>qw", ":wqa<CR>", desc = "Write & Quit All" },
	},
})
