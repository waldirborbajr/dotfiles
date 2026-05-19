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

-- Restore cursor position
autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_location', { clear = true }),
  desc = 'Go to last cursor position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd 'normal! g`"zz' end
  end,
})

-- Disable auto comment continuation
autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', { clear = true }),
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

-- Disable next line comments
autocmd('BufEnter', {
  callback = function()
    vim.cmd 'set formatoptions-=cro'
    vim.cmd 'setlocal formatoptions-=cro'
  end,
})

autocmd({ 'BufNewFile', 'BufFilePre', 'BufRead' }, {
  pattern = { '*.mdx', '*.md' },
  callback = function() vim.cmd [[set filetype=markdown wrap linebreak nolist nospell]] end,
})


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitsendemail', 'conf', 'editorconfig', 'qf', 'checkhealth', 'less' },
  callback = function(event) vim.bo[event.buf].syntax = vim.bo[event.buf].filetype end,
})

-- autocmds {{{
vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'clear trailing whitespace on write',
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[ %s/\s\+$//e ]])
        vim.fn.winrestview(view)
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'highlight selection on yank',
    callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'TermEnter', 'TermLeave' }, {
    desc = 'cd to terminal cwd on enter',
    pattern = 'term://*',
    callback = function()
        local cwd = vim.fn.resolve('/proc/' .. vim.b.terminal_job_pid .. '/cwd')
        if vim.fn.isdirectory(cwd) == 1 then
            vim.fn.chdir(cwd)
        end
    end,
})

vim.api.nvim_create_autocmd('BufLeave', {
    desc = 'restore scrolloff when leaving a terminal buffer',
    pattern = 'term://*',
    callback = function() vim.o.scrolloff = options.scrolloff end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'try to start treesitter for supported filetypes',
    callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'set keywordprg for vim files',
    pattern = 'vim',
    command = [[ setlocal keywordprg=:vert\ help ]],
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'set tab to 1 to enable folding by indent',
    pattern = 'man',
    command = [[ setlocal sw=1 ts=1 ]],
})

vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'unfold folds on buffer enter',
    command = [[ silent! normal zR ]],
})
-- }}}

require 'custom.indent'
