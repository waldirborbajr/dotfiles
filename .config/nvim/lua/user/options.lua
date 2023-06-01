vim.cmd [[ command! Q :q! ]]
vim.cmd [[ cabbrev vf vert sf ]]

-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    spell = false, -- sets vim.opt.spell
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto
    wrap = false, -- sets vim.opt.wrap
    -- Post config
    virtualedit = "onemore", -- allow the cursor to go to the end of the line
    -- backup = true, -- if you want to have backup
    completeopt = "menuone,preview",
    smarttab = true, -- insert spaces instead of tabs
    tabstop = 2, -- number of spaces a tab counts for
    expandtab = true, -- use spaces instead of tabs
    shiftwidth = 2, -- number of spaces to use for autoindent
    smartindent = false, -- make indenting smart
    -- showbreak = "↪",
    -- listchars = { tab = ">·", space = "·" },
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
  },
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
