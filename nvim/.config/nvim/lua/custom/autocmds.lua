-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add custom autocmds here using:
-- vim.api.nvim_create_autocmd(...)
--
-- Default LazyVim autocmd groups can be removed with:
-- vim.api.nvim_del_augroup_by_name("lazyvim_<group_name>")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ============================================================================
-- Restore last cursor position when reopening a file
-- ============================================================================
autocmd("BufReadPost", {
  group = augroup("last_location", { clear = true }),
  desc = "Restore last cursor position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd([[normal! g`"zz]])
    end
  end,
})

-- ============================================================================
-- Disable automatic comment continuation
-- ============================================================================
autocmd("FileType", {
  group = augroup("no_auto_comment", { clear = true }),
  desc = "Disable automatic comment continuation",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- ============================================================================
-- Ensure comment continuation is disabled on buffer enter
-- ============================================================================
autocmd("BufEnter", {
  desc = "Disable next line comments",
  callback = function()
    vim.cmd([[set formatoptions-=cro]])
    vim.cmd([[setlocal formatoptions-=cro]])
  end,
})

-- ============================================================================
-- Markdown specific settings
-- ============================================================================
autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  desc = "Apply markdown settings",
  pattern = { "*.md", "*.mdx" },
  callback = function()
    vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
  end,
})

-- ============================================================================
-- Fix syntax highlighting for special buffer types
-- ============================================================================
autocmd("FileType", {
  desc = "Fix syntax highlighting for special buffers",
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

-- ============================================================================
-- Remove trailing whitespace before saving files
-- ============================================================================
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  callback = function()
    local view = vim.fn.winsaveview()

    vim.cmd([[%s/\s\+$//e]])

    vim.fn.winrestview(view)
  end,
})

-- ============================================================================
-- Highlight yanked text
-- ============================================================================
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ============================================================================
-- Change current working directory to terminal cwd
-- ============================================================================
autocmd({ "BufEnter", "TermEnter", "TermLeave" }, {
  desc = "Sync cwd with terminal buffer",
  pattern = "term://*",
  callback = function()
    local cwd = vim.fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")

    if vim.fn.isdirectory(cwd) == 1 then
      vim.fn.chdir(cwd)
    end
  end,
})

-- ============================================================================
-- Save and restore scrolloff for terminal buffers
-- ============================================================================
autocmd("TermEnter", {
  desc = "Save scrolloff before entering terminal",
  pattern = "term://*",
  callback = function()
    vim.b.saved_scrolloff = vim.o.scrolloff
    vim.o.scrolloff = 0
  end,
})

autocmd("BufLeave", {
  desc = "Restore scrolloff after leaving terminal",
  pattern = "term://*",
  callback = function()
    if vim.b.saved_scrolloff ~= nil then
      vim.o.scrolloff = vim.b.saved_scrolloff
    end
  end,
})

-- ============================================================================
-- Start Tree-sitter automatically for supported filetypes
-- ============================================================================
autocmd("FileType", {
  desc = "Start Tree-sitter automatically",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- ============================================================================
-- Improve help lookup for Vim script files
-- ============================================================================
autocmd("FileType", {
  desc = "Set keywordprg for Vim files",
  pattern = "vim",
  command = [[setlocal keywordprg=:vert\ help]],
})

-- ============================================================================
-- Configure manual pages for indent-based folding
-- ============================================================================
autocmd("FileType", {
  desc = "Configure man page indentation",
  pattern = "man",
  command = [[setlocal sw=1 ts=1]],
})

-- ============================================================================
-- Open all folds automatically when entering a buffer
-- ============================================================================
autocmd("BufEnter", {
  desc = "Open all folds on buffer enter",
  command = [[silent! normal zR]],
})

-- Load custom indentation settings
require("custom.indent")
