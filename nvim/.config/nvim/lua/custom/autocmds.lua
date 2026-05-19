-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Restore cursor position
autocmd("BufReadPost", {
  group = augroup("last_location", { clear = true }),
  desc = "Go to last cursor position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd([[normal! g`"zz]])
    end
  end,
})

-- Disable auto comment continuation
autocmd("FileType", {
  group = augroup("no_auto_comment", { clear = true }),
  desc = "Disable auto comment continuation",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable next line comments
autocmd("BufEnter", {
  desc = "Disable next line comments",
  callback = function()
    vim.cmd([[set formatoptions-=cro]])
    vim.cmd([[setlocal formatoptions-=cro]])
  end,
})

-- Markdown settings
autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  desc = "Markdown settings",
  pattern = { "*.mdx", "*.md" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

-- Fix syntax highlighting for special buffers
autocmd("FileType", {
  desc = "Fix syntax highlighting",
  pattern = {
    "gitsendemail",
    "conf",
    "editorconfig",
    "qf",
    "checkhealth",
    "less",
  },
  callback = function(event)
    vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
  end,
})

-- Clear trailing whitespace on write
autocmd("BufWritePre", {
  desc = "Clear trailing whitespace on write",
  callback = function()
    local view = vim.fn.winsaveview()

    vim.cmd([[%s/\s\+$//e]])

    vim.fn.winrestview(view)
  end,
})

-- Highlight selection on yank
autocmd("TextYankPost", {
  desc = "Highlight selection on yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- CD to terminal cwd on enter
autocmd({ "BufEnter", "TermEnter", "TermLeave" }, {
  desc = "CD to terminal cwd on enter",
  pattern = "term://*",
  callback = function()
    local cwd = vim.fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")

    if vim.fn.isdirectory(cwd) == 1 then
      vim.fn.chdir(cwd)
    end
  end,
})

-- Restore scrolloff when leaving a terminal buffer
autocmd("BufLeave", {
  desc = "Restore scrolloff when leaving a terminal buffer",
  pattern = "term://*",
  callback = function()
    vim.o.scrolloff = options.scrolloff
  end,
})

-- Try to start treesitter for supported filetypes
autocmd("FileType", {
  desc = "Try to start treesitter for supported filetypes",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Set keywordprg for vim files
autocmd("FileType", {
  desc = "Set keywordprg for vim files",
  pattern = "vim",
  command = [[setlocal keywordprg=:vert\ help]],
})

-- Set tab to 1 to enable folding by indent
autocmd("FileType", {
  desc = "Set tab to 1 to enable folding by indent",
  pattern = "man",
  command = [[setlocal sw=1 ts=1]],
})

-- Unfold folds on buffer enter
autocmd("BufEnter", {
  desc = "Unfold folds on buffer enter",
  command = [[silent! normal zR]],
})

require("custom.indent")
