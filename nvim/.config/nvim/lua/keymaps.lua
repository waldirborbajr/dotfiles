-- =============================================
-- LEADER
-- =============================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================
-- CLIPBOARD & REGISTER BEHAVIOR
-- =============================================
local map = vim.keymap.set

-- Better clipboard integration
map({ "n", "x" }, "<C-y>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-p>", '"+p', { desc = "Paste from system clipboard" })

-- Delete / Change without yanking to default register
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })
map({ "n", "x" }, "c", [["_c]], { desc = "Change without yanking" })
map({ "n", "x" }, "C", [["_C]], { desc = "Change line without yanking" })

-- Special x behavior (delete char without yanking + handle blank lines)
local function delete_char_or_blank_line()
  if vim.fn.col(".") == 1 and vim.fn.getline("."):match("^%s*$") then
    vim.api.nvim_feedkeys('"_dd', "n", false)
    vim.api.nvim_feedkeys("$", "n", false)
  else
    vim.api.nvim_feedkeys('"_x', "n", false)
  end
end

map({ "n", "x" }, "x", delete_char_or_blank_line, { desc = "Delete char/line without yanking" })
map({ "n", "x" }, "X", delete_char_or_blank_line, { desc = "Delete char/line without yanking" })

-- Visual paste behavior
map("x", "p", [["_dP]], { desc = "Paste over selection without losing register" })
map("x", "P", "p", { desc = "Yank selection then paste" })

-- =============================================
-- MOVEMENT & CURSOR
-- =============================================
-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down + center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up + center" })

-- Centered search navigation
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Better j/k with word wrap
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- =============================================
-- VISUAL MODE ENHANCEMENTS
-- =============================================
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Unindent and keep selection" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })

map("v", "<C-s>", "<cmd>sort<CR>", { desc = "Sort selection" })
map("v", "<leader>rr", '"hy:%s/<C-r>h//g<Left><Left>', { desc = "Replace selection" })

-- =============================================
-- WINDOW & SPLIT MANAGEMENT
-- =============================================
-- Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window",  remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resizing
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- =============================================
-- BUFFERS & TABS
-- =============================================
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "[b",    "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b",    "<cmd>bnext<CR>",     { desc = "Next buffer" })

map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to alternate buffer" })
map("n", "<leader>`",  "<cmd>e #<CR>", { desc = "Switch to alternate buffer" })

map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })
map("n", "<leader>bD", "<cmd>bd<CR>", { desc = "Delete buffer + window" })

-- Tab navigation
map("n", "<Tab>",   "<cmd>bn<CR>", { desc = "Next buffer (tab)" })
map("n", "<S-Tab>", "<cmd>bp<CR>", { desc = "Previous buffer (tab)" })

-- =============================================
-- MISCELLANEOUS
-- =============================================
map("i", "<C-c>", "<Esc>", { desc = "Esc alternative" })

map("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlight", silent = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor globally" })

map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- UndoTree (lazy loaded)
map("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end, { desc = "Toggle Undotree" })

-- Restart config (if using a custom command)
map("n", "<leader>re", "<cmd>restart<CR>", { desc = "Restart Neovim config" })

local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- paste over selection without loosing yanked
vim.keymap.set("x", "p", [["_dP]])

-- leader d delete wont remember as yanked/clipboard when delete pasting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

-- format built in
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- prevent x delete from registering when next paste
vim.keymap.set("n", "x", '"_x', opts)

-- Replace the word cursor is on globally
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word cursor is on globally" })
-- Executes shell command from in here making file executable
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")   --open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>") --close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")     --go to next
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")     --go to pre
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>") --open current tab in new tab

--split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
-- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
-- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
-- close current split window
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filePath = vim.fn.expand("%:~")
    vim.fn.setreg("+", filePath)
    print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

-- restart 
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", {
    desc = "Restart Neovim (:restart)",
})

vim.keymap.set("n", "<leader>lr", function()
    vim.cmd("lsp restart")
    vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })


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

------ xxxxx ------

-- Visual mode sorting and replacements
vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>")
vim.keymap.set("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>')

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- Indentation in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Better up/down navigation
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Move lines with Alt
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Tab navigation
vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

-- Open parent directory
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Remove search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })