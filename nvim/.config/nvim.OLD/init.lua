--[[
Neovim Configuration Example
Notes:
1. To fully use mini.pick, you need to install ripgrep, otherwise only git-based search will work.
   On Windows, you can install it via winget:
     winget install BurntSushi.ripgrep.MSVC
   To search for other versions:
     winget search ripgrep
2. This configuration uses the built-in Neovim 0.12 API (vim.pack) for plugin management.
--]]

----------------------
-- General Neovim Settings --
----------------------
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Tab width is 2 spaces
vim.opt.shiftwidth = 2 -- Indentation width is 2
vim.opt.wrap = false -- Disable line wrapping
vim.opt.scrolloff = 5 -- Keep 5 lines above/below cursor
vim.opt.signcolumn = "yes" -- Always show sign column (diagnostics)
vim.opt.winborder = "rounded" -- Window border style
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase is used
vim.opt.hlsearch = false -- Do not highlight search matches
vim.opt.incsearch = true -- Incremental search
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Treesitter-based folding
vim.opt.foldlevel = 99 -- Do not fold by default when opening files
vim.g.mapleader = " " -- Set leader key to space

----------------------
-- Autocommands --
----------------------
-- Auto format before saving
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
	pattern = "*",
})

-- Highlight copied text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight copying text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})

----------------------
-- Plugins Loaded at Startup --
----------------------
vim.pack.add({
	{ src = "https://github.com/morhetz/gruvbox" }, -- Theme
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- Syntax highlighting and folding
})

vim.cmd("colorscheme gruvbox")

----------------------
-- Autocompletion --
----------------------
-- Install blink.cmp and lazy-load on insert
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
}, {
	load = function(plug_data)
		vim.api.nvim_create_autocmd("InsertEnter", {
			once = true,
			callback = function()
				vim.cmd.packadd(plug_data.spec.name)
				-- Load plugin config
				require("blink.cmp").setup({
					keymap = { preset = "super-tab" },
					sources = {
						default = { "lsp", "path", "snippets", "buffer" },
					},
				})
			end,
		})
	end,
})

----------------------
-- Utility Plugin Config --
----------------------
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pick" }, -- File/buffer picker
	{ src = "https://github.com/nvim-mini/mini.files" }, -- File explorer
}, { load = false })

-- Actually not strictly necessary
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- mini.pick setup
		require("mini.pick").setup()
		-- mini.files setup
		require("mini.files").setup({
			windows = {
				preview = true, -- Enable preview window
			},
		})
	end,
})

----------------------
-- LSP Configuration --
----------------------
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" }, -- LSP installer/manager
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- LSP config
}, {
	load = function(plug_data)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "python", "c", "cpp" },
			callback = function()
				vim.cmd.packadd(plug_data.spec.name)
				require("mason").setup()
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT", path = vim.split(package.path, ";") }, -- Lua runtime
							diagnostics = { globals = { "vim" } }, -- Ignore global 'vim'
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							format = { enable = true }, -- Enable formatting
						},
					},
				})

				vim.diagnostic.config({ virtual_text = true }) -- Inline diagnostics
			end,
		})
	end,
})

-- Enable LSP servers
vim.lsp.enable({ "lua_ls", "pyright", "clangd" })

----------------------
-- Keymaps --
----------------------
-- Format
vim.keymap.set("n", "<leader>lf", function()
	vim.lsp.buf.format()
end, { desc = "format" })

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>c", '"+y', { desc = "copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"+d', { desc = "cut to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "paste from system clipboard" })

-- Window navigation
vim.keymap.set("n", "<leader>ww", "<C-w>w", { desc = "focus windows" })

-- Move lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- File / plugin shortcuts
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<ESC>:write<CR>", { desc = "save file" })
vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<CR>", { desc = "open file explorer" })
vim.keymap.set("n", "<leader>f", ":Pick files<CR>", { desc = "open file picker" })
vim.keymap.set("n", "<leader>h", ":Pick help<CR>", { desc = "open help picker" })
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>", { desc = "open buffer picker" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "diagnostic messages" })

-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

-- Quick diagnostic navigation
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ wrap = true, count = -1 })
end, { desc = "previous diagnostic" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ wrap = true, count = 1 })
end, { desc = "next diagnostic" })
