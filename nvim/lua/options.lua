require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
-- Backup / Swap
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

--------------------------------------------------------------------------------
--- Commands
--------------------------------------------------------------------------------
---
-- Disable continuation comment on next line
vim.api.nvim_create_autocmd("User", {
  desc = "no auto comment after pressing o",
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})

-- Disable nvim-cmp for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})

---- Commands
-------------------------------------------------------------------------------

-- Open Github repository
vim.api.nvim_create_user_command("OpenGithubRepo", function(_)
  local ghpath = vim.api.nvim_eval("shellescape(expand('<cfile>'))")
  local formatpath = ghpath:sub(2, #ghpath - 1)
  local repourl = "https://www.github.com/" .. formatpath
  vim.fn.system({ "xdg-open", repourl })
end, {
  desc = "Open Github Repo",
  force = true,
})

-- Custom commands
vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope smart_open]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])
vim.cmd([[command! -nargs=0 SmartGoTo :Telescope smart_goto]])

--------------------------------------------------------------------------------
--- KeyMap
--------------------------------------------------------------------------------
---
-- files
vim.keymap.set("n", "!!", ":qa!<enter>", { desc = "" })
vim.keymap.set("n", "QQ", ":q!<enter>", { desc = "" })
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "WW", ":w!<enter>", { desc = "" })
vim.keymap.set("n", "E", "$", { desc = "" })
vim.keymap.set("n", "B", "^", { desc = "" })
vim.keymap.set("n", "td", ":TodoTelescope<CR>", { desc = "" })
vim.keymap.set("n", "<leader>rs", ":%s/", { desc = "" })
vim.keymap.set("n", "<leader>rw", ":%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "" })
vim.keymap.set("n", "<leader>gH", "<cmd>OpenGithubRepo<cr>", { desc = "Open GitHub Repo" })

-- Custom navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "" })
vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "" })
vim.keymap.set("n", "<C-b>", "<C-b>zz", { desc = "" })
