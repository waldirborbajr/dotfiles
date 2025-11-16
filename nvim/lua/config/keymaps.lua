-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>a", function()
  vim.cmd("argadd %")
  vim.cmd("argdedup")
end)

vim.keymap.set("n", "<leader>r", function()
  vim.cmd.args()
end)

vim.keymap.set("n", "<C-h>", function()
  vim.cmd("silent! 1argument")
end)

vim.keymap.set("n", "<C-j>", function()
  vim.cmd("silent! 2argument")
end)

vim.keymap.set("n", "<C-k>", function()
  vim.cmd("silent! 3argument")
end)

vim.keymap.set("n", "<C-l>", function()
  vim.cmd("silent! 4argument")
end)
