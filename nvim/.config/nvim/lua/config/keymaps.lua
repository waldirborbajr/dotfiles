-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
-- clipboard ---------------------------------------------------------------
map("n", "<C-y>", '"+y', { desc = "Copy to cliboard" })
map("x", "<C-y>", '"+y', { desc = "Copy to cliboard" })
map("n", "<C-p>", '"+p', { desc = "Paste from clipboard" })

-- Make 'c' key not copy to clipboard when changing a character.
map("n", "c", '"_c', { desc = "Change without yanking" })
map("n", "C", '"_C', { desc = "Change without yanking" })
map("x", "c", '"_c', { desc = "Change without yanking" })
map("x", "C", '"_C', { desc = "Change without yanking" })

local function delete_char_or_blank_line()
  if vim.fn.col(".") == 1 and vim.fn.getline("."):match("^%s*$") then
    vim.api.nvim_feedkeys('"_dd', "n", false)
    vim.api.nvim_feedkeys("$", "n", false)
  else
    vim.api.nvim_feedkeys('"_x', "n", false)
  end
end

-- Make 'x' key not copy to clipboard when deleting a character
map("n", "x", delete_char_or_blank_line, { desc = "Delete character without yanking" })
map("n", "X", delete_char_or_blank_line, { desc = "Delete character without yanking" })
map("x", "x", '"_x', { desc = "Delete selection without yanking" })
map("x", "X", '"_x', { desc = "Delete selection without yanking" })

-- Override nvim default behavior so it doesn't auto-yank when pasting on visual mode.
map("x", "p", "P", { desc = "Paste content you've previourly yanked" })
map("x", "P", "p", { desc = "Yank what you are going to override, then paste" })

vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>") -- Sort highlighted text in visual mode with Control+S
vim.keymap.set("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up

vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Remove search highlights after searching
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vim's terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
