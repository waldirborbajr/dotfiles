
-- =========================================================
-- KEYMAP HELPER
-- =========================================================
local map = vim.keymap.set

local opts = {
    noremap = true,
    silent = true,
}

-- =========================================================
-- CLIPBOARD & REGISTER BEHAVIOR
-- =========================================================

-- System clipboard integration
map({ "n", "x" }, "<C-y>", '"+y', {
    desc = "Copy to system clipboard",
})

map("n", "<C-p>", '"+p', {
    desc = "Paste from system clipboard",
})

-- Delete/change without yanking
map({ "n", "x" }, "<leader>d", [["_d]], {
    desc = "Delete without yanking",
})

map({ "n", "x" }, "c", [["_c]], {
    desc = "Change without yanking",
})

map({ "n", "x" }, "C", [["_C]], {
    desc = "Change line without yanking",
})

-- Delete character without yanking
local function delete_char_or_blank_line()
    if vim.fn.col(".") == 1 and vim.fn.getline("."):match("^%s*$") then
        vim.api.nvim_feedkeys('"_dd', "n", false)
        vim.api.nvim_feedkeys("$", "n", false)
    else
        vim.api.nvim_feedkeys('"_x', "n", false)
    end
end

map({ "n", "x" }, "x", delete_char_or_blank_line, {
    desc = "Delete character without yanking",
})

map({ "n", "x" }, "X", delete_char_or_blank_line, {
    desc = "Delete character without yanking",
})

-- Keep register content when pasting in visual mode
map("x", "p", [["_dP]], {
    desc = "Paste without overwriting register",
})

map("x", "P", "p", {
    desc = "Paste and keep replaced text",
})

-- =========================================================
-- MOVEMENT & CURSOR
-- =========================================================

-- Better wrapped line navigation
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true,
    desc = "Move down",
})

map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true,
    desc = "Move up",
})

map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    silent = true,
    desc = "Move down",
})

map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    silent = true,
    desc = "Move up",
})

-- Keep cursor centered while scrolling
map("n", "<C-d>", "<C-d>zz", {
    desc = "Scroll down and center cursor",
})

map("n", "<C-u>", "<C-u>zz", {
    desc = "Scroll up and center cursor",
})

-- Keep cursor centered while searching
map("n", "n", "nzzzv", {
    desc = "Next search result",
})

map("n", "N", "Nzzzv", {
    desc = "Previous search result",
})

-- Join lines without moving cursor
map("n", "J", "mzJ`z", {
    desc = "Join lines without moving cursor",
})

-- =========================================================
-- VISUAL MODE
-- =========================================================

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", {
    desc = "Move selection down",
})

map("v", "K", ":m '<-2<CR>gv=gv", {
    desc = "Move selection up",
})

-- Indentation
map("v", "<", "<gv", {
    desc = "Indent left",
})

map("v", ">", ">gv", {
    desc = "Indent right",
})

-- Sort selection
map("v", "<C-s>", "<cmd>sort<CR>", {
    desc = "Sort selection",
})

-- Replace selected text
map("v", "<leader>rr", '"hy:%s/<C-r>h//g<Left><Left>', {
    desc = "Replace selection globally",
})

-- =========================================================
-- MOVE LINES WITH ALT
-- =========================================================

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", {
    desc = "Move line down",
})

map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", {
    desc = "Move line up",
})

map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", {
    desc = "Move line down",
})

map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", {
    desc = "Move line up",
})

map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", {
    desc = "Move selection down",
})

map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", {
    desc = "Move selection up",
})

-- =========================================================
-- WINDOW & SPLIT MANAGEMENT
-- =========================================================

-- Window navigation
map("n", "<C-h>", "<C-w>h", {
    desc = "Go to left window",
    remap = true,
})

map("n", "<C-j>", "<C-w>j", {
    desc = "Go to lower window",
    remap = true,
})

map("n", "<C-k>", "<C-w>k", {
    desc = "Go to upper window",
    remap = true,
})

map("n", "<C-l>", "<C-w>l", {
    desc = "Go to right window",
    remap = true,
})

-- Split creation
map("n", "<leader>sv", "<C-w>v", {
    desc = "Split window vertically",
})

map("n", "<leader>sh", "<C-w>s", {
    desc = "Split window horizontally",
})

map("n", "<leader>se", "<C-w>=", {
    desc = "Equalize split sizes",
})

map("n", "<leader>sx", "<cmd>close<CR>", {
    desc = "Close current split",
})

-- Window resizing
map("n", "<C-Up>", "<cmd>resize +2<CR>", {
    desc = "Increase window height",
})

map("n", "<C-Down>", "<cmd>resize -2<CR>", {
    desc = "Decrease window height",
})

map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", {
    desc = "Decrease window width",
})

map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", {
    desc = "Increase window width",
})

-- =========================================================
-- BUFFERS
-- =========================================================

map("n", "<S-h>", "<cmd>bprevious<CR>", {
    desc = "Previous buffer",
})

map("n", "<S-l>", "<cmd>bnext<CR>", {
    desc = "Next buffer",
})

map("n", "[b", "<cmd>bprevious<CR>", {
    desc = "Previous buffer",
})

map("n", "]b", "<cmd>bnext<CR>", {
    desc = "Next buffer",
})

map("n", "<leader>bb", "<cmd>e #<CR>", {
    desc = "Switch to alternate buffer",
})

map("n", "<leader>`", "<cmd>e #<CR>", {
    desc = "Switch to alternate buffer",
})

map("n", "<leader>bd", function()
    Snacks.bufdelete()
end, {
    desc = "Delete buffer",
})

map("n", "<leader>bo", function()
    Snacks.bufdelete.other()
end, {
    desc = "Delete other buffers",
})

map("n", "<leader>bD", "<cmd>bd<CR>", {
    desc = "Delete buffer and window",
})

-- =========================================================
-- TABS
-- =========================================================

map("n", "<Tab>", "<cmd>bn<CR>", {
    desc = "Next buffer",
})

map("n", "<S-Tab>", "<cmd>bp<CR>", {
    desc = "Previous buffer",
})

map("n", "<leader>to", "<cmd>tabnew<CR>", {
    desc = "Open new tab",
})

map("n", "<leader>tx", "<cmd>tabclose<CR>", {
    desc = "Close current tab",
})

map("n", "<leader>tn", "<cmd>tabnext<CR>", {
    desc = "Next tab",
})

map("n", "<leader>tp", "<cmd>tabprevious<CR>", {
    desc = "Previous tab",
})

map("n", "<leader>tf", "<cmd>tabnew %<CR>", {
    desc = "Open current buffer in new tab",
})

-- =========================================================
-- SEARCH & REPLACE
-- =========================================================

map(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    {
        desc = "Replace word under cursor globally",
    }
)

-- =========================================================
-- FILES & UTILITIES
-- =========================================================

-- Open parent directory with Oil
map("n", "-", "<CMD>Oil<CR>", {
    desc = "Open parent directory",
})

-- Make current file executable
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", {
    silent = true,
    desc = "Make current file executable",
})

-- Copy file path to clipboard
map("n", "<leader>fp", function()
    local filepath = vim.fn.expand("%:~")

    vim.fn.setreg("+", filepath)

    print("Copied file path: " .. filepath)
end, {
    desc = "Copy file path to clipboard",
})

-- Reload current file
map("n", "<leader><leader>", function()
    vim.cmd("so")
end, {
    desc = "Reload current file",
})

-- =========================================================
-- LSP
-- =========================================================

map("n", "<leader>f", vim.lsp.buf.format, {
    desc = "Format current buffer",
})

map("n", "<leader>lr", function()
    vim.cmd("LspRestart")
    vim.notify("LSP restarted", vim.log.levels.INFO)
end, {
    desc = "Restart LSP",
})

-- =========================================================
-- SEARCH HIGHLIGHT
-- =========================================================

map("n", "<C-c>", "<cmd>nohl<CR>", {
    desc = "Clear search highlight",
    silent = true,
})

map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
    desc = "Clear search highlight",
})

-- =========================================================
-- INSERT MODE
-- =========================================================

map("i", "<C-c>", "<Esc>", {
    desc = "Exit insert mode",
})

-- =========================================================
-- TERMINAL
-- =========================================================

map("t", "<Esc><Esc>", "<C-\\><C-n>", {
    desc = "Exit terminal mode",
})

-- =========================================================
-- UNDOTREE
-- =========================================================

map("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, {
    desc = "Toggle Undotree",
})

-- =========================================================
-- NEOVIM RESTART
-- =========================================================

map("n", "<leader>re", "<cmd>restart<CR>", {
    desc = "Restart Neovim",
})
