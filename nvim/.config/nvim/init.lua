-- =============================================================
-- Neovim 0.12 Optimized init.lua (Native-first, No Treesitter)
-- Compliant with Neovim 0.12 news (vim.lsp.enable, diagnostics, ui2, vim.pack)
-- =============================================================

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
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
vim.opt.winborder = "rounded" -- 0.12: native rounded borders everywhere
vim.opt.completeopt = "menu,menuone,noinsert,popup"
vim.opt.autocomplete = true -- 0.12: native auto-completion
vim.o.complete = "o,.,i" -- o: Omnifunc (LSP), .: Current buffer, i: Included files

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- New UI opt-in
-- require("vim._core.ui2").enable({})

-- Preview substitutions live, as you type
vim.opt.inccommand = "split"

-- Diagnostics
vim.diagnostic.config({
	virtual_text = {
		current_line = true,
		source = "if_many",
		prefix = "●",
		spacing = 20,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●", --"",
			[vim.diagnostic.severity.WARN] = "●", --"",
			[vim.diagnostic.severity.INFO] = "●", --"",
			[vim.diagnostic.severity.HINT] = "●", --"",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- ====================== Basic Options ======================
-- vim.o.background = "dark"
-- vim.o.backup = false
-- vim.o.swapfile = false
-- vim.o.expandtab = true
-- vim.o.shiftwidth = 2
-- vim.o.tabstop = 2
-- vim.o.softtabstop = 2
-- vim.o.smartindent = true
-- vim.o.autoindent = true
-- vim.opt.backspace = { "start", "eol", "indent" }

-- vim.o.number = true
-- vim.o.relativenumber = true
-- vim.o.scrolloff = 8
-- vim.o.signcolumn = "yes"
-- vim.o.showmode = false
-- vim.o.wrap = false
-- vim.o.termguicolors = true
-- vim.o.updatetime = 50
-- vim.o.winborder = "rounded"
-- vim.o.hlsearch = true
-- vim.o.incsearch = true

-- vim.opt.title = true
-- vim.opt.path:append({ "**" })
-- vim.opt.wildignore:append({ "*/node_modules/*" })
-- vim.opt.splitbelow = true
-- vim.opt.splitright = true

-- -- Undercurl support
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- -- Format options
-- vim.opt.formatoptions:append({ "r" })

-- -- Native completion fallback (0.12)
-- vim.o.autocomplete = true

-- ====================== Plugins ======================
local gh = function(p)
	return "https://github.com/" .. p
end

vim.pack.add({ gh("sam4llis/nvim-tundra") })
vim.pack.add({ gh("tpope/vim-sleuth") })
vim.pack.add({ gh("rcarriga/nvim-notify") })
vim.pack.add({ gh("MunifTanjim/nui.nvim") })
vim.pack.add({ gh("folke/noice.nvim") })
vim.pack.add({ gh("neovim/nvim-lspconfig") })
vim.pack.add({ gh("Saghen/blink.cmp") })
vim.pack.add({ gh("nvim-neo-tree/neo-tree.nvim") })
vim.pack.add({ gh("echasnovski/mini.files") })
vim.pack.add({ gh("stevearc/oil.nvim") })
vim.pack.add({ gh("nvim-lua/plenary.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope.nvim") })
vim.pack.add({ gh("supermaven-inc/supermaven-nvim") })
vim.pack.add({ gh("stevearc/conform.nvim") })
vim.pack.add({ gh("rachartier/tiny-inline-diagnostic.nvim") })
vim.pack.add({ gh("nvim-tree/nvim-web-devicons") })
vim.pack.add({ gh("nvim-lualine/lualine.nvim") })
vim.pack.add({ gh("sindrets/diffview.nvim") })
vim.pack.add({ gh("akinsho/toggleterm.nvim") })
vim.pack.add({ gh("folke/which-key.nvim") })
vim.pack.add({ gh("kdheepak/lazygit.nvim") })
vim.pack.add({ gh("windwp/nvim-autopairs") })

-- vim.pack.add({
-- 	{ src = "https://github.com/sam4llis/nvim-tundra" },
-- 	{ src = "https://github.com/tpope/vim-sleuth" },
-- 	{ src = "https://github.com/rcarriga/nvim-notify" },
-- 	{ src = "https://github.com/MunifTanjim/nui.nvim" },
-- 	{ src = "https://github.com/folke/noice.nvim" },
-- 	{ src = "https://github.com/neovim/nvim-lspconfig" },
-- 	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
-- 	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
-- 	{ src = "https://github.com/echasnovski/mini.files" },
-- 	{ src = "https://github.com/stevearc/oil.nvim" },
-- 	{ src = "https://github.com/nvim-lua/plenary.nvim" },
-- 	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
-- 	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
-- 	{ src = "https://github.com/stevearc/conform.nvim" },
-- 	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
-- 	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
-- 	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
-- 	{ src = "https://github.com/sindrets/diffview.nvim" },
-- 	{ src = "https://github.com/akinsho/toggleterm.nvim" },
-- 	{ src = "https://github.com/folke/which-key.nvim" },
-- 	{ src = "https://github.com/kdheepak/lazygit.nvim" },
-- 	{ src = "https://github.com/windwp/nvim-autopairs" },
-- })

-- ====================== UI2 (0.12 feature) ======================
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

-- ====================== ToggleTerm ======================
require("toggleterm").setup({
	direction = "float",
	open_mapping = [[<C-\>]],
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	shade_terminals = true,
	close_on_exit = false,
	float_opts = {
		border = "rounded",
		winblend = 0,
	},
	highlights = {
		Normal = { guibg = "#0d0f15" },
		NormalFloat = { link = "Normal" },
		FloatBorder = { guifg = "#3d425a", guibg = "#0d0f15" },
	},
})

-- Custom terminal functions
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

-- ====================== Colorscheme ======================
vim.cmd.colorscheme("tundra")

-- ====================== Which-key ======================
require("config.which-key-config")

-- ====================== Noice ======================
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

-- ====================== Neo-tree ======================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_modified_markers = true,
	enable_diagnostics = true,
	sort_case_insensitive = false,
	window = {
		position = "left",
		width = 30,
		mapping_options = { noremap = true, nowait = true },
		mappings = {
			["<space>"] = "toggle_node",
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["t"] = "open_tabnew",
			["w"] = "open_window",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["a"] = { "add", config = { show_path = "relative" } },
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy",
			["m"] = "move",
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
			["<"] = "prev_source",
			[">"] = "next_source",
			["i"] = "show_file_details",
		},
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = true,
			hide_hidden = false,
		},
		follow_current_file = { enabled = true },
		group_empty_dirs = false,
		use_libuv_file_watcher = true,
	},
})

-- ====================== nvim-autopairs ======================
require("nvim-autopairs").setup({
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	check_ts = false,
	enable_check_bracket_line = true,
	ignored_next_char = "[%w%.]",
})

-- ====================== Supermaven ======================
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

-- ====================== Conform ======================
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "autopep8" },
		javascript = { "biome" },
		typescript = { "prettier" },
		json = { "prettier" },
		toml = { "tombi" },
		-- markdown = { "prettier" },
		markdown = { "oxfmt", "prettier", stop_after_first = true },
		["markdown.mdx"] = { "oxfmt", "prettier", stop_after_first = true },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
		--		go = { "gofumpt" },
		go = { "goimports", "gofmt", stop_after_first = true },
		yaml = { "yamlfmt" },
	},
	format_on_save = {
		timeout_ms = 2000,
		lsp_fallback = true,
	},
	formatters = {
		prettier = { prepend_args = { "--tab-width", "4", "--use-tabs", "true" } },
		stylua = { prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" } },
		clang_format = { prepend_args = { "--style={UseTab: ForIndentation, TabWidth: 4, IndentWidth: 4}" } },
		rustfmt = { prepend_args = { "--config", "hard_tabs=true", "--config", "tab_spaces=4" } },
		gofumpt = { prepend_args = { "--tabs=true", "--tabwidth=4" } },
		autopep8 = { prepend_args = { "--indent-size=4" } },
	},
})

-- ====================== Lualine ======================
require("lualine").setup({
	options = {
		theme = "tundra",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{
				"branch",
				fmt = function(str)
					if #str > 5 then
						return str:sub(1, 5) .. "…"
					end
					return str
				end,
			},
			"diff",
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				file_status = true,
				fmt = function(str)
					local sep = package.config:sub(1, 1)
					local parts = {}
					for part in string.gmatch(str, "([^" .. sep .. "]+)") do
						table.insert(parts, part)
					end
					if #parts == 1 then
						return parts[1]
					end
					local result = {}
					for i = 1, #parts - 1 do
						table.insert(result, parts[i]:sub(1, 1))
					end
					table.insert(result, parts[#parts])
					return table.concat(result, sep)
				end,
			},
		},
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_c = { { "filename", path = 1, file_status = true } },
	},
})

-- ====================== Mini.files + Oil ======================
require("mini.files").setup()

require("oil").setup({
	default_file_explorer = true,
	columns = { "icon" },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	prompt_save_on_select_new_entry = true,
	cleanup_delay_ms = 2000,
	constrain_cursor = "name",
	watch_for_changes = true,
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["sv"] = { "actions.select", opts = { vertical = true } },
		["sh"] = { "actions.select", opts = { horizontal = true } },
		["st"] = { "actions.select", opts = { tab = true } },
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["<BS>"] = { "actions.parent", mode = "n" },
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["q"] = { "actions.close", mode = "n" },
		["<C-q>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
	},
	use_default_keymaps = false,
	view_options = {
		show_hidden = true,
		natural_order = true,
		case_insensitive = true,
		sort = { { "type", "asc" }, { "name", "asc" } },
		wrap = true,
	},
	float = { padding = 2, border = "rounded" },
	preview_win = { update_on_cursor_moved = true, preview_method = "fast_scratch" },
})

-- ====================== Notify ======================
require("notify").setup({
	render = "minimal",
	animation = { style = "slide" },
	top_down = false,
	timeout = 2000,
})

-- ====================== Tiny Inline Diagnostic ======================
require("tiny-inline-diagnostic").setup({
	preset = "minimal",
	transparent_bg = false,
	transparent_cursorline = true,
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText",
		background = "CursorLine",
		mixing_color = "Normal",
	},
	options = {
		show_source = { enabled = false },
		show_code = true,
		multilines = { enabled = false },
		show_all_diags_on_cursorline = false,
		show_diags_only_under_cursor = false,
	},
})

-- ====================== Blink.cmp (must be before get_lsp_capabilities) ======================
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = true },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust" },
})

-- ====================== Native LSP (0.12 style) ======================
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.enable({ "lua_ls", "rust_analyzer", "gopls" })

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("gopls", {
	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
			gofumpt = true,
		},
	},
	init_options = { usePlaceholders = false },
})

-- ====================== Diagnostics (0.12 compliant) ======================
-- vim.diagnostic.config({
-- 	severity_sort = true,
-- 	update_in_insert = false,
-- 	float = { border = "rounded", source = "if_many" },
-- 	underline = true,
-- 	virtual_text = {
-- 		spacing = 2,
-- 		source = "if_many",
-- 		prefix = "●",
-- 	},
-- })

-- ====================== Keymaps ======================
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "qq", ":split<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "sv", ":vsplit<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Space><Space>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>t", "<Cmd>lua _toggle_terminal()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>T", "<Cmd>lua _close_terminal_completely()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>-", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Float", noremap = true, silent = true })

-- Terminal keymaps
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

-- ====================== LSP Attach Keymaps ======================
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
		end

		map("n", "K", vim.lsp.buf.hover, "Hover Info")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

		map("n", "<leader>lnd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "<leader>lnD", vim.lsp.buf.declaration, "Go to Declaration")
		map("n", "<leader>lni", vim.lsp.buf.implementation, "Go to Implementation")
		map("n", "<leader>lnr", vim.lsp.buf.references, "References")

		map("n", "<leader>lrn", vim.lsp.buf.rename, "Rename Symbol")
		map({ "n", "v" }, "<leader>lra", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>lrf", function()
			vim.lsp.buf.format({ async = true })
		end, "Format Buffer")

		-- Add your other LSP keymaps here if needed
	end,
})

-- ====================== Tundra ======================
require("nvim-tundra").setup({
	plugins = { telescope = true },
})

-- ====================== Autocmds ======================
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local function session_path()
    local name = vim.fn.getcwd():gsub("[/\\:]", "_")
    return vim.fn.stdpath("data") .. "/sessions/" .. name .. ".vim"
end

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        if vim.fn.argc() > 0 then return end
        local path = session_path()
        if vim.fn.filereadable(path) == 1 then
            vim.cmd("silent! source " .. vim.fn.fnameescape(path))
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local path = session_path()
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
        vim.cmd("mksession! " .. vim.fn.fnameescape(path))
    end,
})

-- Disable auto comment continuation
autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Highlight on yank
autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("yank_highlight", { clear = true }),
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- Restore cursor position
autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("last_location", { clear = true }),
	desc = "Go to last cursor position",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- Set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("env_filetype"),
	pattern = { "*.env", ".env.*" },
	callback = function()
		vim.opt_local.filetype = "sh"
	end,
})

-- Set filetype for .toml files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("toml_filetype"),
	pattern = { "*.tomg-config*" },
	callback = function()
		vim.opt_local.filetype = "toml"
	end,
})

print("Neovim 0.13 config loaded successfully!")
