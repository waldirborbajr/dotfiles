-- =============================================
-- AUTOCOMMANDS
-- =============================================
-- Autocmds are automatically loaded on the VeryLazy event

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ============================================================================
-- BUFFER & CURSOR
-- ============================================================================
-- Restore last cursor position when reopening a file
autocmd("BufReadPost", {
	group = augroup("last_location", { clear = true }),
	desc = "Restore last cursor position",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd([[normal! g`"zz]])
		end
	end,
})

-- ============================================================================
-- FOLDS & DISPLAY
-- ============================================================================
-- Open all folds automatically
autocmd("BufEnter", {
	group = augroup("open_folds", { clear = true }),
	desc = "Open all folds on buffer enter",
	command = "silent! normal! zR",
})

-- Highlight yanked text
autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- ============================================================================
-- COMMENT HANDLING
-- ============================================================================
-- Disable automatic comment continuation on new lines
autocmd({ "FileType", "BufEnter" }, {
	group = augroup("no_auto_comment", { clear = true }),
	desc = "Disable automatic comment continuation",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
		vim.cmd([[setlocal formatoptions-=cro]])
	end,
})

-- ============================================================================
-- FILETYPE SPECIFIC SETTINGS
-- ============================================================================
-- Markdown settings
autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
	group = augroup("markdown_settings", { clear = true }),
	desc = "Apply markdown specific settings",
	pattern = { "*.md", "*.mdx" },
	callback = function()
		vim.cmd([[set filetype=markdown wrap linebreak nolist nospell]])
	end,
})

-- Fix syntax highlighting for special buffers
autocmd("FileType", {
	group = augroup("syntax_highlighting_fix", { clear = true }),
	desc = "Fix syntax highlighting for special buffers",
	pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth", "less" },
	callback = function(event)
		vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
	end,
})

-- Vim filetype specific
autocmd("FileType", {
	group = augroup("vim_help_lookup", { clear = true }),
	desc = "Set keywordprg for Vim files",
	pattern = "vim",
	command = "setlocal keywordprg=:vert\\ help",
})

-- Man pages
autocmd("FileType", {
	group = augroup("man_page_indent", { clear = true }),
	desc = "Configure man page indentation",
	pattern = "man",
	command = "setlocal sw=1 ts=1",
})

-- Use real tabs for Go and Rust
autocmd("FileType", {
	group = augroup("tab_for_indent", { clear = true }),
	desc = "Use hard tabs for Go and Rust",
	pattern = { "go", "rust" },
	callback = function()
		vim.bo.expandtab = false
	end,
})

-- Auto-start Tree-sitter
-- autocmd('FileType', {
--   group = augroup('treesitter_start', { clear = true }),
--   desc = 'Start Tree-sitter automatically',
--   callback = function()
--     pcall(vim.treesitter.start)
--   end,
-- })

-- ============================================================================
-- TEXT EDITING
-- ============================================================================
-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = augroup("remove_trailing_whitespace", { clear = true }),
	desc = "Remove trailing whitespace on save",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- ============================================================================
-- TERMINAL BEHAVIOR
-- ============================================================================
-- Sync working directory with terminal
autocmd({ "BufEnter", "TermEnter", "TermLeave" }, {
	group = augroup("terminal_cwd_sync", { clear = true }),
	desc = "Sync cwd with terminal buffer",
	pattern = "term://*",
	callback = function()
		local cwd = vim.fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")
		if vim.fn.isdirectory(cwd) == 1 then
			vim.fn.chdir(cwd)
		end
	end,
})

-- Better terminal UX (scrolloff)
autocmd("TermEnter", {
	group = augroup("terminal_scrolloff", { clear = true }),
	desc = "Disable scrolloff in terminal",
	pattern = "term://*",
	callback = function()
		vim.b.saved_scrolloff = vim.o.scrolloff
		vim.o.scrolloff = 0
	end,
})

autocmd("BufLeave", {
	group = augroup("terminal_scrolloff_restore", { clear = true }),
	desc = "Restore scrolloff after leaving terminal",
	pattern = "term://*",
	callback = function()
		if vim.b.saved_scrolloff ~= nil then
			vim.o.scrolloff = vim.b.saved_scrolloff
		end
	end,
})

-- ============================================================================
-- USER COMMANDS
-- ============================================================================
-- Custom packer commands
-- NOTE: pack add
vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (PackAdd user/repo)", })

--:packupdate :packupdate! :packdel :packdel! now supported in 0.13 nightly as of May 17
-- NOTE: pack delete
vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)", })

-- NOTE: pack update
vim.api.nvim_create_user_command("PackUpdate", function(opts)
    if opts.args ~= "" then
        -- update specific plugins
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
        vim.pack.update(plugins)
    else
        -- update all
        vim.pack.update()
    end
end, { desc = "Update all plugins or specific ones", nargs = "*", })

-- NOTE: pack nonactive - show all non active plugins on disk but removed from pack.lua
vim.api.nvim_create_user_command("PackCheck", function()
    local non_active = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    if #non_active == 0 then
        vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
        return
    end

    vim.print("😴 Non-active plugins :")
    print(" ")
    for _, name in ipairs(non_active) do
        print(name)
    end

    print(" ")

    local choice = vim.fn.confirm(
        "Delete ALL non-active plugins from disk?",
        "&Yes\n&No",
        2  -- default = No
    )

    if choice == 1 then
        vim.pack.del(non_active)
        vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
        print("Non-active plugins deleted!")
        vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
    else
        vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
    end
end, { desc = "List non active plugins and select to delete"})

-- ============================================================================
-- CUSTOM CONFIG
-- ============================================================================
require("indent")
