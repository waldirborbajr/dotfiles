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
-- BUFFER HANDLING
-- ============================================================================

-- Restore last cursor position when reopening a file
-- Moves cursor to the last position when you open a previously edited file
autocmd('BufReadPost', {
  group = augroup('last_location', { clear = true }),
  desc = 'Restore last cursor position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then vim.cmd [[normal! g`"zz]] end
  end,
})

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Open all folds automatically when entering a buffer
-- Expands all folded regions so all code is visible
autocmd('BufEnter', {
  group = augroup('open_folds', { clear = true }),
  desc = 'Open all folds on buffer enter',
  command = [[silent! normal zR]],
})

-- ============================================================================
-- COMMENT HANDLING (Consolidated)
-- ============================================================================

-- Disable automatic comment continuation on new lines
-- Prevents vim from automatically inserting comment characters (# // --)
-- when pressing Enter in a comment. Consolidates two separate autocmds
-- into a single unified approach using both FileType and BufEnter events
autocmd('FileType', {
  group = augroup('no_auto_comment', { clear = true }),
  desc = 'Disable automatic comment continuation',
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

autocmd('BufEnter', {
  group = augroup('no_auto_comment_buf', { clear = true }),
  desc = 'Ensure comment continuation is disabled on buffer enter',
  callback = function()
    vim.cmd [[set formatoptions-=cro]]
    vim.cmd [[setlocal formatoptions-=cro]]
  end,
})

-- ============================================================================
-- FILETYPE-SPECIFIC SETTINGS
-- ============================================================================

-- Apply markdown-specific settings to .md and .mdx files
-- Enables word wrapping, shows line breaks, disables list formatting and spell check
autocmd({ 'BufNewFile', 'BufFilePre', 'BufRead' }, {
  group = augroup('markdown_settings', { clear = true }),
  desc = 'Apply markdown settings',
  pattern = { '*.md', '*.mdx' },
  callback = function() vim.cmd [[set filetype=markdown wrap linebreak nolist nospell]] end,
})

-- Fix syntax highlighting for special buffer types
-- Ensures correct syntax highlighting for special filetypes
autocmd('FileType', {
  group = augroup('syntax_highlighting_fix', { clear = true }),
  desc = 'Fix syntax highlighting for special buffers',
  pattern = {
    'gitsendemail',
    'conf',
    'editorconfig',
    'qf',
    'checkhealth',
    'less',
  },
  callback = function(event) vim.bo[event.buf].syntax = vim.bo[event.buf].filetype end,
})

-- Set proper help lookup for Vim script files
-- Allows pressing K on a Vim command to open help vertically
autocmd('FileType', {
  group = augroup('vim_help_lookup', { clear = true }),
  desc = 'Set keywordprg for Vim files',
  pattern = 'vim',
  command = [[setlocal keywordprg=:vert\ help]],
})

-- Configure manual pages for indent-based folding
-- Sets tab width for man pages to 1 space for proper formatting
autocmd('FileType', {
  group = augroup('man_page_indent', { clear = true }),
  desc = 'Configure man page indentation',
  pattern = 'man',
  command = [[setlocal sw=1 ts=1]],
})

-- Use actual tabs instead of spaces for specific filetypes
-- Go and Rust prefer hard tabs for indentation
autocmd('FileType', {
  pattern = { 'go', 'rust' },
  group = augroup('tab_for_indent', { clear = true }),
  desc = 'Use tabs instead of spaces for Go and Rust',
  callback = function()
    vim.bo.expandtab = false -- Use actual tab character instead of spaces
    -- vim.bo.tabstop = 4 -- Number of spaces per tab display
    -- vim.bo.shiftwidth = 4 -- Number of spaces for auto-indentation
  end,
})

-- Start Tree-sitter automatically for supported filetypes
-- Enables syntax highlighting powered by Tree-sitter parser
autocmd('FileType', {
  group = augroup('treesitter_start', { clear = true }),
  desc = 'Start Tree-sitter automatically',
  callback = function() pcall(vim.treesitter.start) end,
})

-- ============================================================================
-- TEXT EDITING & DISPLAY
-- ============================================================================

-- Remove trailing whitespace before saving files
-- Cleans up unnecessary spaces at the end of lines
autocmd('BufWritePre', {
  group = augroup('remove_trailing_whitespace', { clear = true }),
  desc = 'Remove trailing whitespace on save',
  callback = function()
    local view = vim.fn.winsaveview()

    vim.cmd [[%s/\s\+$//e]]

    vim.fn.winrestview(view)
  end,
})

-- Highlight yanked text
-- Visual feedback when text is copied/yanked to show selection
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  desc = 'Highlight yanked text',
  callback = function() vim.hl.on_yank() end,
})

-- ============================================================================
-- TERMINAL & WORKING DIRECTORY
-- ============================================================================

-- Synchronize current working directory with terminal buffer
-- Changes Neovim's working directory to match the terminal's directory
autocmd({ 'BufEnter', 'TermEnter', 'TermLeave' }, {
  group = augroup('terminal_cwd_sync', { clear = true }),
  desc = 'Sync cwd with terminal buffer',
  pattern = 'term://*',
  callback = function()
    local cwd = vim.fn.resolve('/proc/' .. vim.b.terminal_job_pid .. '/cwd')

    if vim.fn.isdirectory(cwd) == 1 then vim.fn.chdir(cwd) end
  end,
})

-- Save scrolloff value before entering terminal mode
-- Removes scrolloff (context lines) when in terminal for better interactivity
autocmd('TermEnter', {
  group = augroup('terminal_scrolloff', { clear = true }),
  desc = 'Save scrolloff before entering terminal',
  pattern = 'term://*',
  callback = function()
    vim.b.saved_scrolloff = vim.o.scrolloff
    vim.o.scrolloff = 0
  end,
})

-- Restore scrolloff value after leaving terminal mode
-- Restores the original scrolloff setting when exiting terminal
autocmd('BufLeave', {
  group = augroup('terminal_scrolloff_restore', { clear = true }),
  desc = 'Restore scrolloff after leaving terminal',
  pattern = 'term://*',
  callback = function()
    if vim.b.saved_scrolloff ~= nil then vim.o.scrolloff = vim.b.saved_scrolloff end
  end,
})

-- ============================================================================
-- LOAD CUSTOM INDENTATION SETTINGS
-- ============================================================================

require 'custom.indent'
