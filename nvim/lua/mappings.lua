require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "File Format with conform" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "!!", ":qa!<enter>", { desc = "" })
map("n", "QQ", ":q!<enter>", { desc = "" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "WW", ":w!<enter>", { desc = "" })
map("n", "E", "$", { desc = "" })
map("n", "B", "^", { desc = "" })
map("n", "td", ":TodoTelescope<CR>", { desc = "" })
map("n", "<leader>rs", ":%s/", { desc = "" })
map("n", "<leader>rw", ":%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "" })
map("n", "<leader>gH", "<cmd>OpenGithubRepo<cr>", { desc = "Open GitHub Repo" })

-- Custom navigation
map("n", "<C-d>", "<C-d>zz", { desc = "" })
map("n", "<C-u>", "<C-u>zz", { desc = "" })
map("n", "<C-f>", "<C-f>zz", { desc = "" })
map("n", "<C-b>", "<C-b>zz", { desc = "" })

map("n", "<C-h>", function()
  vim.cmd "TmuxNavigateLeft"
end, { desc = "window left" })
map("n", "<C-l>", function()
  vim.cmd "TmuxNavigateRight"
end, { desc = "window right" })
map("n", "<C-j>", function()
  vim.cmd "TmuxNavigateDown"
end, { desc = "window down" })
map("n", "<C-k>", function()
  vim.cmd "TmuxNavigateUp"
end, { desc = "window up" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

map("n", "<leader>gg", "<cmd> LazyGit <cr>", { desc = "Lazygit" })
