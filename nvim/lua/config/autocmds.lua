-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- Disable continuation comment on next line

vim.api.nvim_create_autocmd("User", {
  desc = "no auto comment after pressing o",
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})
