vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Scrolloff
local scrolloff = math.floor(vim.o.lines / 2) - 3
vim.opt.scrolloff = scrolloff

require("plugins.init")
require("config.autocmd")
require("config.binds")

-- Colorcheme
vim.cmd.colorscheme("catppuccin-mocha")

-- Line numbers
vim.opt.cursorline = true
vim.wo.relativenumber = true
vim.wo.number = true
vim.api.nvim_set_hl(0, "LineNr", { fg = "#6c7086" }) -- overlay0
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#cba6f7", bold = true }) -- mauve

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.winborder = "rounded"

-- Sane tab management
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

-- Undo management
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Better Highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Nowrap
vim.opt.wrap = false

-- Indent
vim.o.autoindent = true

-- Undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)

-- Local project config
vim.o.exrc = true
