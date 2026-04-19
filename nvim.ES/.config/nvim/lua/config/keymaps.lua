-- Leader key
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- ====================================
-- General Mappings
-- ====================================

-- Normal Mode
vim.keymap.set("n", "<C-s>", ":w<CR>", opts)
vim.keymap.set("n", "<C-q>", ":q<CR>", opts)
vim.keymap.set("n", "<leader>o", "o<Esc>k", opts)

-- Insert Mode
vim.keymap.set("i", "<C-s>", "<Cmd>w<CR>", opts)
vim.keymap.set("i", "<C-q>", "<Esc>", opts)

-- Visual Mode
vim.keymap.set("v", "y", '"+y"<CR>', opts) -- copy to system clipboard

-- Disable search highlight
vim.keymap.set("n", "//", ":nohlsearch<CR>", opts)

-- Buffer Navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<A-w>", ":Bdelete<CR>", opts)

-- ====================================
-- Visual Mode – Line Movement and Indentation
-- ====================================
vim.keymap.set("x", "K", ":<C-u>move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "J", ":<C-u>move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", ">", ">gv", opts)
vim.keymap.set("x", "<", "<gv", opts)
vim.keymap.set("x", "<CR>", ":<C-u>normal! gv<CR><Esc>", opts)

-- ====================================
-- Oil
-- ====================================
vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Float" }, opts)
-- ====================================
-- ToggleTerm
-- ====================================
vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=horizontal<CR>", opts)
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", opts)
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", opts)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)

-- ====================================
-- Inlay Hints
-- ====================================
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("InlayHintsToggle", {}),
	callback = function(ev)
		vim.keymap.set("n", "<leader>uh", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
		end, { desc = "Alternar Inlay Hints", buffer = ev.buf })
	end,
})

-- ====================================
-- LSP
-- ====================================
--
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		-- Keymaps
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "i", "n" }, "<A-,>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

		-- Luasnip navegación
		vim.keymap.set({ "i", "s" }, "<C-A-k>", function()
			local luasnip = require("luasnip")
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end, opts)

		vim.keymap.set({ "i", "s" }, "<C-A-j>", function()
			local luasnip = require("luasnip")
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, opts)

		-- Formateo
		vim.keymap.set({ "n", "i" }, "<A-S-f>", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, opts)
	end,
})
