vim.g.mapleader = " "
vim.opt.relativenumber = true
vim.o.background = "dark"
vim.o.backup = false
vim.o.expandtab = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.number = true
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 50
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.o.autocomplete = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- Plugins
vim.pack.add({
	{ src = "https://github.com/sam4llis/nvim-tundra" },
	-- { src = "https://github.com/sphamba/smear-cursor.nvim" },
	-- { src = "https://github.com/wakatime/vim-wakatime" },
	{ src = "https://github.com/tpope/vim-sleuth" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	-- { src = "https://github.com/mason-org/mason.nvim.git" },
	-- { src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/echasnovski/mini.files" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
})
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

-- Custom toggle terminal (mantiene el proceso activo)
local Terminal = require("toggleterm.terminal").Terminal
local default_terminal = Terminal:new({
	hidden = false,
})

function _toggle_terminal()
	default_terminal:toggle()
end

-- Cierra y mata la terminal completamente
function _close_terminal_completely()
	if default_terminal then
		default_terminal:close()
		default_terminal:shutdown()
		default_terminal = Terminal:new({
			hidden = false,
		})
	end
end

-- Lazygit keybinding
vim.keymap.set("n", "<leader>gg", "<Cmd>LazyGit<CR>", { noremap = true, silent = true })

-- Colorscheme
vim.cmd.colorscheme("tundra")

-- Which-key setup
require("config.which-key-config")

-- Noice setup
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

-- Mason setup
-- require("mason").setup()
-- require("mason-lspconfig").setup({
-- 	ensure_installed = {
-- 		"stylua",
-- 		-- "rust_analyzer",
-- 		-- "gopls",
-- 		"lua_ls",
-- 	},
-- })

-- nvim-tree setup
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
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = "toggle_node",
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["t"] = "open_tabnew",
			["w"] = "open_window",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["a"] = {
				"add",
				config = {
					show_path = "relative",
				},
			},
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
		follow_current_file = {
			enabled = true,
		},
		group_empty_dirs = false,
		use_libuv_file_watcher = true,
	},
})
-- blink.cmp setup
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust" },
})

-- nvim-autopairs setup
require("config.autopairs-config")

-- Supermaven setup
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

-- Conform setup
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "autopep8" },
		javascript = { "biome" },
		typescript = { "prettier" },
		json = { "prettier" },
		toml = { "tombi" },
		markdown = { "prettier" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
		go = { "gofumpt" },
		yaml = { "yamlfmt" },
	},
	format_on_save = {
		timeout_ms = 2000,
		lsp_fallback = true,
	},
	formatters = {
		prettier = {
			inherit = true,
			prepend_args = { "--tab-width", "4", "--use-tabs", "true" },
		},
		stylua = {
			inherit = true,
			prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" },
		},
		clang_format = {
			inherit = true,
			prepend_args = { "--style={UseTab: ForIndentation, TabWidth: 4, IndentWidth: 4}" },
		},
		rustfmt = {
			inherit = true,
			prepend_args = { "--config", "hard_tabs=true", "--config", "tab_spaces=4" },
		},
		gofumpt = {
			inherit = true,
			prepend_args = { "--tabs=true", "--tabwidth=4" },
		}, -- gofmt/gofumpt usa tabs por defecto, no necesita config extra
		autopep8 = {
			-- autopep8 no soporta tabs: fuerza 4 espacios por defecto (sin opción para tabs)
			inherit = true,
			prepend_args = { "--indent-size=4" },
		},
	},
})

-- Lualine setup
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
	tabline = {},
	inactive_sections = {
		lualine_c = { { "filename", path = 1, file_status = true } },
	},
	extensions = {},
})

-- Mini.files setup
require("mini.files").setup()

-- Oil setup
require("oil").setup({
	default_file_explorer = true,

	-- columns = {
	--  "icon",
	--  "size",
	--  "mtime",
	-- },
	columns = {
		"icon",
	},

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
		["<BS>"] = { "actions.parent", mode = "n" }, -- Backspace para subir
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["q"] = { "actions.close", mode = "n" },
		["<C-q>"] = { "actions.close", mode = "n" }, -- cerrar también con Ctrl+q
		["<C-l>"] = "actions.refresh",
	},

	use_default_keymaps = false,

	view_options = {
		show_hidden = true,
		natural_order = true,
		case_insensitive = true,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
		wrap = true,
	},

	float = {
		padding = 2,
		border = "rounded",
	},

	preview_win = {
		update_on_cursor_moved = true,
		preview_method = "fast_scratch",
	},
})

-- nvim-notify setup
require("notify").setup({
	render = "minimal",
	animation = {
		style = "slide",
	},
	top_down = false,
	timeout = 2000,
})

-- Tiny inline diagnostics setup
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
	disabled_ft = {},
	options = {
		show_source = {
			enabled = false,
			if_many = false,
		},
		show_code = true,
		use_icons_from_diagnostic = false,
		set_arrow_to_diag_color = false,
		throttle = 20,
		softwrap = 30,
		add_messages = {
			messages = true,
			display_count = false,
			use_max_severity = false,
			show_multiple_glyphs = true,
		},
		multilines = {
			enabled = false,
			always_show = false,
			trim_whitespaces = false,
			tabstop = 4,
			severity = nil,
		},
		show_all_diags_on_cursorline = false,
		show_diags_only_under_cursor = false,
		show_related = {
			enabled = true,
			max_count = 3,
		},
		enable_on_insert = false,
		enable_on_select = false,
		overflow = {
			mode = "wrap",
			padding = 0,
		},
		break_line = {
			enabled = false,
			after = 30,
		},
		format = nil,
		virt_texts = {
			priority = 2048,
		},
		severity = {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
			vim.diagnostic.severity.HINT,
		},
		overwrite_events = nil,
		override_open_float = false,
		experimental = {
			use_window_local_extmarks = false,
		},
	},
})

-- LSP Configuration (Neovim 0.12 native)
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Enable LSP servers
vim.lsp.enable({
	"lua_ls",
	"rust_analyzer",
	-- "bashls",
	"gopls",
	-- "helm_ls",
	-- "pyright",
	-- "rust-analyzer",
	-- "texlab",
	-- "ts_ls",
	-- "yamlls",
})

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = { enable = false },
		},
	},
})

-- vim.lsp.config("ts_ls", {
-- 	capabilities = capabilities,
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 			},
-- 		},
-- 	},
-- })

vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
})

vim.lsp.config("basedpyright", {
	capabilities = capabilities,
})

vim.lsp.config("jsonls", {})
vim.lsp.config("gopls", {})
--:

-- Diagnostic configuration
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = "rounded",
		source = "if_many",
	},
	underline = true,
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "●",
	},
})

--: Basic keymaps
-- Global keymaps (window navigation and file explorer)
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- Split window
vim.keymap.set("n", "qq", ":split<Return>", { noremap = true, silent = true })
vim.keymap.set("n", "sv", ":vsplit<Return>", { noremap = true, silent = true })

vim.keymap.set("n", "<Space><Space>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>t", "<Cmd>lua _toggle_terminal()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>T", "<Cmd>lua _close_terminal_completely()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<A-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w>", ":bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-w>", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>-", "<Cmd>Oil<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>-", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Float" }, { noremap = true, silent = true })
--:

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
--:

-- Autocommands
-- Disable auto comment continuation
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
--:

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
		end

		-- Basic Navigation
		map("n", "K", vim.lsp.buf.hover, "Hover Info")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

		-- Navigation keymaps (registered in which-key)
		map("n", "<leader>lnd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "<leader>lnD", vim.lsp.buf.declaration, "Go to Declaration")
		map("n", "<leader>lni", vim.lsp.buf.implementation, "Go to Implementation")
		map("n", "<leader>lnr", vim.lsp.buf.references, "References")
		map("n", "<leader>lnt", vim.lsp.buf.type_definition, "Type Definition")

		-- Refactoring keymaps (registered in which-key)
		map("n", "<leader>lrn", vim.lsp.buf.rename, "Rename Symbol")
		map({ "n", "v" }, "<leader>lra", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>lrf", function()
			vim.lsp.buf.format({ async = true })
		end, "Format Buffer")

		-- Imports keymaps (registered in which-key)
		map("n", "<leader>lio", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.organizeImports" },
				},
				apply = true,
			})
		end, "Organize Imports")

		map("n", "<leader>liu", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.removeUnused" },
				},
				apply = true,
			})
		end, "Remove Unused Imports")

		map("n", "<leader>lim", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.addMissingImports" },
				},
				apply = true,
			})
		end, "Add Missing Imports")

		-- Symbols/Outline keymaps (registered in which-key)
		map("n", "<leader>lsd", function()
			if package.loaded["snacks"] then
				Snacks.picker.lsp_symbols()
			else
				vim.lsp.buf.document_symbol()
			end
		end, "Document Symbols")

		map("n", "<leader>lsw", function()
			if package.loaded["snacks"] then
				Snacks.picker.lsp_workspace_symbols()
			else
				vim.lsp.buf.workspace_symbol()
			end
		end, "Workspace Symbols")

		-- Calls keymaps (registered in which-key)
		map("n", "<leader>lci", function()
			if package.loaded["snacks"] then
				Snacks.picker.lsp_incoming_calls()
			else
				vim.lsp.buf.incoming_calls()
			end
		end, "Incoming Calls")

		map("n", "<leader>lco", function()
			if package.loaded["snacks"] then
				Snacks.picker.lsp_outgoing_calls()
			else
				vim.lsp.buf.outgoing_calls()
			end
		end, "Outgoing Calls")

		-- Diagnostics keymaps (registered in which-key)
		map("n", "<leader>ldo", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("n", "<leader>ldp", vim.diagnostic.goto_prev, "Previous Diagnostic")
		map("n", "<leader>ldn", vim.diagnostic.goto_next, "Next Diagnostic")

		map("n", "<leader>lda", function()
			if package.loaded["snacks"] then
				Snacks.picker.diagnostics()
			else
				vim.diagnostic.setloclist()
			end
		end, "All Diagnostics")

		map("n", "<leader>ldb", function()
			if package.loaded["snacks"] then
				Snacks.picker.diagnostics_buffer()
			else
				vim.diagnostic.setqflist()
			end
		end, "Buffer Diagnostics")

		-- Help keymaps (registered in which-key)
		map("n", "<leader>lhh", vim.lsp.buf.hover, "Hover Info")
		map("n", "<leader>lhs", vim.lsp.buf.signature_help, "Signature Help")
	end,
})

require("nvim-tundra").setup({
	plugins = {
		telescope = true,
	},
})
