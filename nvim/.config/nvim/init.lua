-- =============================================================
-- Neovim 0.12 Optimized init.lua (Native-first, No Treesitter)
-- Compliant with Neovim 0.12 - Versão Final
-- =============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ====================== Basic Options ======================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cmdheight = 1
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.textwidth = 80
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.winborder = "rounded"
vim.opt.completeopt = "menu,menuone,noinsert,popup"
vim.opt.autocomplete = true
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "split"

-- ====================== Plugins ======================
local gh = function(p)
	return "https://github.com/" .. p
end

vim.pack.add({
	gh("sam4llis/nvim-tundra"),
	gh("tpope/vim-sleuth"),
	gh("rcarriga/nvim-notify"),
	gh("MunifTanjim/nui.nvim"),
	gh("folke/noice.nvim"),
	gh("neovim/nvim-lspconfig"),
	gh("Saghen/blink.cmp"),
	gh("stevearc/oil.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("supermaven-inc/supermaven-nvim"),
	gh("stevearc/conform.nvim"),
	gh("rachartier/tiny-inline-diagnostic.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("nvim-lualine/lualine.nvim"),
	gh("sindrets/diffview.nvim"),
	gh("akinsho/toggleterm.nvim"),
	gh("folke/which-key.nvim"),
	gh("kdheepak/lazygit.nvim"),
	gh("windwp/nvim-autopairs"),
	gh("ibhagwan/fzf-lua"),
})

-- ====================== Tundra ======================
-- require("nvim-tundra").setup({ plugins = { telescope = true } })
require("nvim-tundra").setup({  })
vim.cmd.colorscheme("tundra")

-- ====================== UI2 ======================
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 1 },
		msg = { height = 0.5, timeout = 4500 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
	},
})

-- ====================== Diagnostics + Tiny Inline ======================
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN]  = "",
			[vim.diagnostic.severity.INFO]  = "",
			[vim.diagnostic.severity.HINT]  = "",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = true, max_width = 80 },
})

require("tiny-inline-diagnostic").setup({
	preset = "modern",
	transparent_bg = false,
	transparent_cursorline = true,
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText",
		background = "CursorLine",
	},
	options = {
		show_source = { enabled = true, if_many = true },
		show_code = true,
		multilines = { enabled = true },
	},
})

-- ====================== Lualine ======================
-- ====================== Lualine (corrigido - sem "no lsp" prematuro) ======================
require("lualine").setup({
	options = {
		theme = "tundra",
		component_separators = { left = "│", right = "│" },
		section_separators = { left = "█", right = "█" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { { "mode", icon = "" } },
		lualine_b = {
			{ "branch", icon = "" },
			{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
		},
		lualine_c = {
			{ "filename", path = 1, file_status = true },
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
		},
		lualine_x = {
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""  -- Não mostra nada se não tiver LSP
					end
					local names = {}
					for _, c in ipairs(clients) do
						table.insert(names, c.name)
					end
					return " " .. table.concat(names, ", ")
				end,
				color = { fg = "#a6e3a1" },
			},
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	extensions = { "oil", "fzf" },
})

-- ====================== Oil.nvim ======================
require("oil").setup({
	default_file_explorer = true,
	columns = { "icon" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	constrain_cursor = "editable",
	watch_for_changes = true,
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-q>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["gx"] = "actions.open_external",
	},
	use_default_keymaps = true,
	float = { padding = 2, border = "rounded" },
	preview_win = { update_on_cursor_moved = true, preview_method = "fast_scratch" },
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil", noremap = true, silent = true })
vim.keymap.set("n", "<leader>-", function()
	require("oil").toggle_float()
end, { desc = "Open Oil (Float)", noremap = true, silent = true })

-- ====================== Supermaven (Sempre Ativado) ======================
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<Tab>",
		clear_suggestion = "<C-]>",
		accept_word = "<C-j>",
	},
	ignore_filetypes = { cpp = true },
	color = {
		suggestion_color = "#ffffff",
		cterm = 244,
	},
	log_level = "info",
	disable_inline_completion = false,
	disable_keymaps = false,
	condition = function()
		return false
	end,
})

-- ====================== ToggleTerm ======================
require("toggleterm").setup({
	direction = "float",
	open_mapping = [[<C-\>]],
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	shade_terminals = true,
	close_on_exit = false,
	float_opts = { border = "rounded", winblend = 0 },
	highlights = {
		Normal = { guibg = "#0d0f15" },
		NormalFloat = { link = "Normal" },
		FloatBorder = { guifg = "#3d425a", guibg = "#0d0f15" },
	},
})

local Terminal = require("toggleterm.terminal").Terminal
local default_terminal = Terminal:new({ hidden = false })

function _G._toggle_terminal()
	default_terminal:toggle()
end

function _G._close_terminal_completely()
	if default_terminal then
		default_terminal:close()
		default_terminal:shutdown()
		default_terminal = Terminal:new({ hidden = false })
	end
end

vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>", { noremap = true, silent = true })

-- ====================== Which-key & Noice ======================
require("config.which-key-config")

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = false,
	},
})

-- ====================== fzf-lua ======================
require("fzf-lua").setup({
	winopts = {
		height = 0.90,
		width = 0.85,
		row = 0.35,
		col = 0.50,
		border = "rounded",
		backdrop = 70,
		preview = { default = "bat" },
	},
})

-- Keymaps fzf-lua (garantido)
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files", silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Live Grep", silent = true })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Buffers", silent = true })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Help Tags", silent = true })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", { desc = "Recent Files", silent = true })
vim.keymap.set("n", "<Space><Space>", "<cmd>FzfLua files<CR>", { desc = "Find Files", silent = true })

-- ====================== Blink.cmp ======================
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = { nerd_font_variant = "mono" },
	completion = {
		documentation = { auto_show = true },
		accept = { auto_brackets = { enabled = true } },
	},
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "prefer_rust" },
})

-- ====================== Native LSP ======================
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.enable({ "lua_ls", "rust_analyzer", "gopls" })

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
			diagnostics = { globals = { "vim" } },
			hint = { enable = true },
		},
	},
})

vim.lsp.config("rust_analyzer", { capabilities = capabilities })
vim.lsp.config("gopls", { capabilities = capabilities })

-- ====================== LSP Attach ======================
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
		end

		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		map("n", "<leader>lnd", vim.lsp.buf.definition, "Definition")
		map("n", "<leader>lnD", vim.lsp.buf.declaration, "Declaration")
		map("n", "<leader>lni", vim.lsp.buf.implementation, "Implementation")
		map("n", "<leader>lnr", vim.lsp.buf.references, "References")
		map("n", "<leader>lrn", vim.lsp.buf.rename, "Rename")
		map({ "n", "v" }, "<leader>lra", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>lrf", function() vim.lsp.buf.format({ async = true }) end, "Format")

		map("n", "<leader>lih", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, "Toggle Inlay Hints")
	end,
})

-- Inlay Hints globais
vim.lsp.inlay_hint.enable(true)

-- Disable arrow keys in all modes
-- local modes = { 'n', 'i', 'v', 'c', 't', 'o', 's', 'x' } -- All possible modes
local modes = { 'n', 'i', 'v', 'o', 't', 's', 'x' } -- All possible modes
-- local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
--
-- for _, mode in ipairs(modes) do
--   for _, key in ipairs(arrows) do
--     vim.keymap.set(mode, key, '<Nop>', { noremap = true, silent = true })
--   end
-- end

local enabledModes = { 'i', 'c', 'o', 't', 's', 'x' }
-- Map Alt + hjkl in Insert mode
for _, mode in ipairs(enabledModes) do
  vim.keymap.set(mode, '<A-h>', '<Left>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-j>', '<Down>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-k>', '<Up>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-l>', '<Right>', { noremap = true, silent = true })
end

-- ====================== Auto-save ======================
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.modified then
			vim.cmd("silent! write")
		end
	end,
})

-- ====================== Session Management ======================
local function session_path()
	local name = vim.fn.getcwd():gsub("[/\\:]", "_")
	return vim.fn.stdpath("data") .. "/sessions/" .. name .. ".vim"
end

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  group = vim.api.nvim_create_augroup("user_session", { clear = true }),
  callback = function()
    -- Clean up stale Telescope references before session loads
    pcall(vim.keymap.del, "n", "<Space><Space>")
    pcall(vim.keymap.del, "n", "<leader>ff")
    pcall(vim.keymap.del, "n", "<leader>fg")
    pcall(vim.keymap.del, "n", "<leader>fb")
    pcall(vim.keymap.del, "n", "<leader>fh")
    pcall(function() vim.cmd("silent! delcommand Telescope") end)

    if vim.fn.argc() > 0 then return end
    local path = session_path()
    if vim.fn.filereadable(path) == 1 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(path))
    end
  end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	nested = true,
-- 	group = vim.api.nvim_create_augroup("user_session", { clear = true }),
-- 	callback = function()
-- 		if vim.fn.argc() > 0 then return end
-- 		local path = session_path()
-- 		if vim.fn.filereadable(path) == 1 then
-- 			vim.cmd("silent! source " .. vim.fn.fnameescape(path))
-- 		end
-- 	end,
-- })

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("user_session", { clear = true }),
	callback = function()
		local path = session_path()
		vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
		vim.cmd("mksession! " .. vim.fn.fnameescape(path))
	end,
})

-- ====================== Autocmds ======================
local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name) return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) end

autocmd("FileType", {
	group = augroup("no_auto_comment"),
	callback = function() vim.opt_local.formatoptions:remove({ "c", "r", "o" }) end,
})

autocmd("TextYankPost", {
	group = augroup("yank_highlight"),
	callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 150 }) end,
})

autocmd("BufReadPost", {
	group = augroup("last_location"),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})


print("Neovim 0.12 config loaded successfully!")
