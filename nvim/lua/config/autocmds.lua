-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- vim.api.nvim_create_autocmd("User", {
--   desc = "no auto comment after pressing o",
--   pattern = "*",
--   command = "setlocal formatoptions-=cro",
-- })
--
-- vim.api.nvim_create_autocmd("BufRead", {
--   callback = function(opts)
--     vim.api.nvim_create_autocmd("BufWinEnter", {
--       once = true,
--       buffer = opts.buf,
--       callback = function()
--         local ft = vim.bo[opts.buf].filetype
--         local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
--         if
--           not (ft:match("commit") and ft:match("rebase"))
--           and last_known_line > 1
--           and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
--         then
--           vim.api.nvim_feedkeys([[g`"]], "nx", false)
--         end
--       end,
--     })
--   end,
-- })

--remove auto-comment
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- make buffer and lualine transparent
vim.api.nvim_create_autocmd({ "UiEnter", "ColorScheme" }, {
  callback = function()
    -- 1.
    vim.cmd([[
      hi TabLineFill gui=nocombine
      hi WinBar gui=nocombine
    ]])
    -- 2.
    vim.cmd([[
      hi TabLineFill guibg=none
      hi WinBar gui=none
    ]])
    -- 3.
    vim.cmd([[
      hi! link TabLineFill Normal
      hi! link WinBar Normal
    ]])
    --4.
    vim.cmd("hi StatusLine guibg=NONE ctermbg=NONE")
  end,
})

-- Dim inactive windows
-- vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.wo.winhighlight = "Normal:Normal,NormalNC:Normal"
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.wo.winhighlight = "Normal:ColorColumn,NormalNC:ColorColumn"
-- 	end,
-- })

-- Show relative line numbers in normal mode, absolute in insert mode
vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  command = "setlocal norelativenumber",
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  command = "setlocal relativenumber",
})

vim.api.nvim_create_user_command("ToggleContrast", function()
  local current = vim.g.high_contrast or false
  if current then
    vim.cmd("colorscheme catppuccin")
    vim.g.high_contrast = false
  else
    vim.cmd("hi Normal guibg=#000000 guifg=#ffffff")
    vim.cmd("hi Comment guifg=#888888")
    vim.g.high_contrast = true
  end
end, {})
