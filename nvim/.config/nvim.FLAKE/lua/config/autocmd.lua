-- =========================================================
-- ALIASES
-- =========================================================
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup

-- =========================================================
-- GIT STATUS CHECK ON STARTUP
-- =========================================================
autocmd("VimEnter", {
	desc = "Check git remote status asynchronously",
	callback = function()
		-- Check if inside a git repository
		local is_git = os.execute("git rev-parse --is-inside-work-tree > /dev/null 2>&1")
		if is_git ~= 0 then return end

		-- Async fetch to avoid blocking startup
		fn.jobstart("git fetch", {
			on_exit = function()
				-- Count commits ahead of local HEAD
				local count = fn.system("git rev-list --count HEAD..@{u} 2>/dev/null"):gsub("%s+", "")

				if count ~= "" and tonumber(count) > 0 then
					vim.schedule(function()
						vim.notify(
							"󰊢 " .. count .. " new commit(s) available on remote.",
							vim.log.levels.INFO,
							{ title = "Git Status" }
						)
					end)
				end
			end,
		})
	end,
})

-- =========================================================
-- CURSOR & UI BEHAVIOR
-- =========================================================
local ui_group = augroup("ui_behavior", { clear = true })

autocmd({ "WinEnter", "BufEnter" }, {
	group = ui_group,
	desc = "Enable cursorline when entering window/buffer",
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

autocmd("WinLeave", {
	group = ui_group,
	desc = "Disable cursorline when leaving window",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- =========================================================
-- FILETYPE SPECIFIC BEHAVIOR
-- =========================================================
local ft_group = augroup("filetype_behavior", { clear = true })

autocmd("FileType", {
	group = ft_group,
	desc = "Start Tree-sitter for Svelte",
	pattern = { "svelte" },
	callback = function()
		vim.treesitter.start()
	end,
})

autocmd("FileType", {
	group = ft_group,
	desc = "Disable auto comment continuation",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

autocmd("FileType", {
	group = ft_group,
	desc = "Fix syntax for special buffers",
	pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth", "less" },
	callback = function(event)
		vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
	end,
})

autocmd("FileType", {
	group = ft_group,
	desc = "Vim help lookup shortcut",
	pattern = "vim",
	command = "setlocal keywordprg=:vert\\ help",
})

autocmd("FileType", {
	group = ft_group,
	desc = "Man page indentation",
	pattern = "man",
	command = "setlocal sw=1 ts=1",
})

autocmd("FileType", {
	group = ft_group,
	desc = "Use tabs for Go and Rust",
	pattern = { "go", "rust" },
	callback = function()
		vim.bo.expandtab = false
	end,
})

-- =========================================================
-- BUFFER BEHAVIOR
-- =========================================================
local buffer_group = augroup("buffer_behavior", { clear = true })

autocmd("BufReadPost", {
	group = buffer_group,
	desc = "Restore last cursor position",
	callback = function(args)
		local mark = api.nvim_buf_get_mark(args.buf, '"')
		local lines = api.nvim_buf_line_count(args.buf)

		if mark[1] > 0 and mark[1] <= lines then
			cmd([[normal! g`"zz]])
		end
	end,
})

autocmd("BufEnter", {
	group = buffer_group,
	desc = "Open all folds on buffer enter",
	command = "silent! normal! zR",
})

-- =========================================================
-- TEXT EDITING
-- =========================================================
local edit_group = augroup("editing", { clear = true })

autocmd("TextYankPost", {
	group = edit_group,
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

autocmd("BufWritePre", {
	group = edit_group,
	desc = "Remove trailing whitespace on save",
	callback = function()
		local view = fn.winsaveview()
		cmd([[%s/\s\+$//e]])
		fn.winrestview(view)
	end,
})

-- =========================================================
-- TERMINAL BEHAVIOR
-- =========================================================
local term_group = augroup("terminal_behavior", { clear = true })

autocmd({ "BufEnter", "TermEnter", "TermLeave" }, {
	group = term_group,
	pattern = "term://*",
	desc = "Sync working directory with terminal",
	callback = function()
		local cwd = fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")
		if fn.isdirectory(cwd) == 1 then
			fn.chdir(cwd)
		end
	end,
})

autocmd("TermEnter", {
	group = term_group,
	pattern = "term://*",
	desc = "Disable scrolloff in terminal",
	callback = function()
		vim.b.saved_scrolloff = vim.o.scrolloff
		vim.o.scrolloff = 0
	end,
})

autocmd("BufLeave", {
	group = term_group,
	pattern = "term://*",
	desc = "Restore scrolloff after terminal",
	callback = function()
		if vim.b.saved_scrolloff then
			vim.o.scrolloff = vim.b.saved_scrolloff
		end
	end,
})

-- =========================================================
-- MARKDOWN BEHAVIOR
-- =========================================================
local md_group = augroup("markdown", { clear = true })

autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
	group = md_group,
	pattern = { "*.md", "*.mdx" },
	desc = "Markdown settings",
	callback = function()
		cmd([[set filetype=markdown wrap linebreak nolist nospell]])
	end,
})

-- =========================================================
-- AUTOSAVE EVENTS
-- =========================================================
local autosave_group = augroup("autosave", { clear = true })

autocmd("User", {
	group = autosave_group,
	pattern = "AutoSaveWritePre",
	desc = "Notify autosave write",
	callback = function(opts)
		if opts.data.saved_buffer then
			local filename = fn.expand("%:t")
			print("Saved '" .. filename .. "' at " .. fn.strftime("%H:%M:%S"))
		end
	end,
})

autocmd("User", {
	group = autosave_group,
	pattern = "AutoSaveEnable",
	desc = "Autosave enabled notification",
	callback = function()
		print("AutoSave enabled")
	end,
})

autocmd("User", {
	group = autosave_group,
	pattern = "AutoSaveDisable",
	desc = "Autosave disabled notification",
	callback = function()
		print("AutoSave disabled")
	end,
})

-- =========================================================
-- USER COMMANDS (PLUGIN MANAGEMENT)
-- =========================================================
api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins" })

api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins" })

api.nvim_create_user_command("PackUpdate", function(opts)
	if opts.args:match("%S") then
		vim.pack.update(vim.split(opts.args, "%s+", { trimempty = true }))
	else
		vim.pack.update()
	end
end, { nargs = "*", desc = "Update plugins" })

api.nvim_create_user_command("PackCheck", function()
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x) return not x.active end)
		:map(function(x) return x.spec.name end)
		:totable()

	if #non_active == 0 then
		vim.notify("No inactive plugins found", vim.log.levels.INFO)
		return
	end

	print("Inactive plugins:")
	for _, name in ipairs(non_active) do print(name) end

	local choice = fn.confirm("Delete all inactive plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(non_active)
		vim.notify("Deleted inactive plugins", vim.log.levels.INFO)
		api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
	end
end, { desc = "Check inactive plugins" })

-- =========================================================
-- MACRO UTILITIES
-- =========================================================
local macro_dir = fn.expand("~/.config/nvim/macros/")

api.nvim_create_user_command("SaveMacro", function(params)
	fn.mkdir(macro_dir, "p")
	fn.writefile({ fn.getreg("q") }, macro_dir .. params.args .. ".macro", "a")
end, { nargs = 1 })

api.nvim_create_user_command("LoadMacro", function(params)
	fn.setreg("q", fn.readfile(macro_dir .. params.args .. ".macro"))
end, { nargs = 1 })

-- =========================================================
-- MISC COMMANDS
-- =========================================================
api.nvim_create_user_command("Reload", function()
	cmd(":source $MYVIMRC")
end, {})

-- =========================================================
-- EXTERNAL MODULES
-- =========================================================
require("indent")
