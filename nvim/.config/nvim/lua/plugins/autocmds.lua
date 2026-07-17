-- =============================================================================
-- AUTOCOMMANDS (AstroNvim recipe pattern)
-- =============================================================================
-- Converted from raw vim.api.nvim_create_autocmd calls to AstroCore's
-- declarative `autocmds` / `commands` tables.
-- https://docs.astronvim.com/recipes/autocmds/
--
-- Each top-level key under `autocmds` is an augroup name; its value is a
-- list of autocmd opt tables (same shape as `:h nvim_create_autocmd`'s
-- {opts}, minus `group`, plus `event`).
--
-- To disable any built-in AstroNvim autocmd group, set its key to `false`
-- in your own override, e.g. `autocmds = { highlightyank = false }`.

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- =====================================================================
        -- PERFORMANCE / GENERAL
        -- =====================================================================

        -- Checks if the file changed outside Neovim (debounced)
        checktime = {
          {
            event = { "FocusGained", "TermClose", "TermLeave" },
            desc = "Check for external file changes (debounced)",
            callback = function()
              local timer = vim.b._checktime_timer
              if timer then
                timer:stop()
                timer:close()
                vim.b._checktime_timer = nil
              end
              vim.b._checktime_timer = vim.defer_fn(function()
                vim.b._checktime_timer = nil
                if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
              end, 200)
            end,
          },
        },

        -- Resizes splits proportionally when the terminal window changes
        resize_splits = {
          {
            event = "VimResized",
            desc = "Rebalance splits on window resize (debounced)",
            callback = function()
              local timer = vim.g._resize_timer
              if timer then
                timer:stop()
                timer:close()
                vim.g._resize_timer = nil
              end
              local current_tab = vim.fn.tabpagenr()
              vim.g._resize_timer = vim.defer_fn(function()
                vim.g._resize_timer = nil
                vim.cmd "tabdo wincmd ="
                vim.cmd("tabnext " .. current_tab)
              end, 100)
            end,
          },
        },

        -- Disable heavy features in very large files (>1MB)
        large_file = {
          {
            event = "BufReadPre",
            desc = "Disable swapfile, spell, folds and treesitter in large files",
            callback = function(event)
              local name = vim.api.nvim_buf_get_name(event.buf)
              local ok, stats = pcall(function() return vim.uv.fs_stat(name) end)
              if ok and stats and stats.size > 1024 * 1024 then
                vim.b[event.buf].large_file = true
                vim.bo[event.buf].swapfile = false
                vim.opt_local.spell = false
                vim.opt_local.foldmethod = "manual"
                vim.schedule(function() pcall(vim.treesitter.stop, event.buf) end)
              end
            end,
          },
        },

        -- =====================================================================
        -- BUFFER & CURSOR
        -- =====================================================================

        -- Automatically creates intermediate directories on save, if they don't exist
        auto_create_dir = {
          {
            event = "BufWritePre",
            desc = "Automatically create destination directory on save",
            callback = function(event)
              if event.match:match "^%w%w+:[\\/][\\/]" then return end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end,
          },
        },

        -- =====================================================================
        -- UI / EDITING EXPERIENCE
        -- =====================================================================

        -- Improves visual performance during insert mode
        insert_ui_perf = {
          {
            event = "InsertEnter",
            desc = "Simplify UI when entering insert mode",
            callback = function()
              vim.wo.cursorline = false
              vim.wo.relativenumber = false
              vim.wo.number = true
            end,
          },
          {
            event = "InsertLeave",
            desc = "Restore UI when leaving insert mode",
            callback = function()
              vim.wo.cursorline = true
              vim.wo.relativenumber = true
            end,
          },
        },

        -- Treats "-" as part of a word in CSS/HTML/JSX etc.
        iskeyword_kebab = {
          {
            event = "FileType",
            desc = "Include '-' in iskeyword for kebab-case based files",
            pattern = { "css", "scss", "less", "html", "htmldjango", "blade", "typescriptreact", "javascriptreact" },
            callback = function() vim.opt_local.iskeyword:append "-" end,
          },
        },

        -- Fixes conceallevel in JSON files (avoids hiding quotes/braces)
        json_conceal = {
          {
            event = "FileType",
            desc = "Disable conceal in JSON files",
            pattern = { "json", "jsonc", "json5" },
            callback = function() vim.opt_local.conceallevel = 0 end,
          },
        },

        -- =====================================================================
        -- SPECIAL FILETYPES (close, indentation, detection)
        -- =====================================================================

        -- Closes certain buffer types with "q" and removes them from the buffer list
        close_with_q = {
          {
            event = "FileType",
            desc = "Close utility buffers with 'q'",
            pattern = {
              "PlenaryTestPopup",
              "checkhealth",
              "dbout",
              "gitsigns-blame",
              "grug-far",
              "help",
              "lspinfo",
              "neotest-output",
              "neotest-output-panel",
              "neotest-summary",
              "notify",
              "qf",
              "spectre_panel",
              "startuptime",
              "tsplayground",
            },
            callback = function(event)
              vim.bo[event.buf].buflisted = false
              vim.schedule(function()
                vim.keymap.set("n", "q", function()
                  vim.cmd "close"
                  pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
                end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
              end)
            end,
          },
        },

        -- Adjustments for man pages
        man_settings = {
          {
            event = "FileType",
            desc = "Unlisted man page buffer + narrow indentation",
            pattern = "man",
            callback = function(event)
              vim.bo[event.buf].buflisted = false
              vim.bo[event.buf].shiftwidth = 1
              vim.bo[event.buf].tabstop = 1
            end,
          },
        },

        -- Wrap, linebreak and spellcheck for "prose" files
        wrap_spell = {
          {
            event = "FileType",
            desc = "Enable wrap, linebreak and spell in text/markdown files",
            pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
              vim.opt_local.spell = true
            end,
          },
        },

        -- Ensures .md/.mdx are detected as markdown
        markdown_filetype = {
          {
            event = { "BufNewFile", "BufFilePre", "BufRead" },
            desc = "Detect .md/.mdx as markdown",
            pattern = { "*.md", "*.mdx" },
            callback = function() vim.bo.filetype = "markdown" end,
          },
        },

        -- Fixes syntax highlighting in special buffers
        syntax_highlighting_fix = {
          {
            event = "FileType",
            desc = "Fix syntax highlighting in special buffers",
            pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth", "less" },
            callback = function(event) vim.bo[event.buf].syntax = vim.bo[event.buf].filetype end,
          },
        },

        -- keywordprg for Vimscript files (search in :help)
        vim_help_lookup = {
          {
            event = "FileType",
            desc = "Use :help as keywordprg in Vim files",
            pattern = "vim",
            command = "setlocal keywordprg=:vert\\ help",
          },
        },

        -- Uses real tabs (not spaces) for Go and Rust
        tab_for_indent = {
          {
            event = "FileType",
            desc = "Use hard tabs in Go and Rust",
            pattern = { "go", "rust" },
            callback = function() vim.bo.expandtab = false end,
          },
        },

        -- Sets filetype for .env and .env.*
        env_filetype = {
          {
            event = { "BufRead", "BufNewFile" },
            desc = "Set filetype=sh for .env files",
            pattern = { "*.env", ".env.*" },
            callback = function() vim.opt_local.filetype = "sh" end,
          },
        },

        -- Sets filetype for *.tomg-config* files
        toml_filetype = {
          {
            event = { "BufRead", "BufNewFile" },
            desc = "Set filetype=toml for *.tomg-config*",
            pattern = { "*.tomg-config*" },
            callback = function() vim.opt_local.filetype = "toml" end,
          },
        },

        -- Sets filetype for .ejs files
        ejs_filetype = {
          {
            event = { "BufRead", "BufNewFile" },
            desc = "Set filetype=embedded_template for .ejs",
            pattern = { "*.ejs", "*.ejs.t" },
            callback = function() vim.opt_local.filetype = "embedded_template" end,
          },
        },

        -- Sets filetype for .code-snippets files
        code_snippets_filetype = {
          {
            event = { "BufRead", "BufNewFile" },
            desc = "Set filetype=json for .code-snippets",
            pattern = { "*.code-snippets" },
            callback = function() vim.opt_local.filetype = "json" end,
          },
        },

        -- =====================================================================
        -- COMMENTS
        -- =====================================================================

        -- Disables automatic comment continuation on new lines
        no_auto_comment = {
          {
            event = { "FileType", "BufEnter" },
            desc = "Disable automatic comment continuation",
            callback = function() vim.opt_local.formatoptions:remove { "c", "r", "o" } end,
          },
        },

        -- =====================================================================
        -- TEXT EDITING
        -- =====================================================================

        -- Removes trailing whitespace at end of lines on save (skips markdown/diff)
        remove_trailing_whitespace = {
          {
            event = "BufWritePre",
            desc = "Remove trailing whitespace on save (except markdown/diff)",
            callback = function(event)
              local exclude = { "markdown", "diff" }
              if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then return end
              local view = vim.fn.winsaveview()
              vim.cmd [[keeppatterns %s/\s\+$//e]]
              vim.fn.winrestview(view)
            end,
          },
        },

        -- Automatically fixes with `oxlint --fix` on save, if the project has a config
        oxlint_fix_on_save = {
          {
            event = "BufWritePre",
            desc = "Run oxlint --fix on save (if configured in the project)",
            pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
            callback = function(args)
              local function root_has_oxlint(path)
                return vim.fs.find({
                  ".oxlintrc.json",
                  ".oxlintrc.jsonc",
                  "oxlint.config.ts",
                }, { upward = true, path = path, stop = vim.loop.os_homedir() })[1] ~= nil
              end

              local path = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))
              if not root_has_oxlint(path) then return end

              local clients = vim.lsp.get_clients { bufnr = args.buf, name = "oxlint" }
              if #clients == 0 then return end

              clients[1]:request_sync("workspace/executeCommand", {
                command = "oxc.fixAll",
                arguments = {
                  { uri = vim.uri_from_bufnr(args.buf), version = vim.lsp.util.buf_versions[args.buf] },
                },
              }, 1000, args.buf)
            end,
          },
        },

        -- =====================================================================
        -- TREE-SITTER
        -- =====================================================================

        -- Starts Tree-sitter automatically via native API
        treesitter_start = {
          {
            event = "FileType",
            desc = "Start Tree-sitter automatically",
            callback = function(event) pcall(vim.treesitter.start, event.buf) end,
          },
        },

        -- =====================================================================
        -- TERMINAL
        -- =====================================================================

        -- Syncs Neovim's cwd with the terminal process directory
        terminal_cwd_sync = {
          {
            event = { "BufEnter", "TermEnter", "TermLeave" },
            desc = "Sync cwd with the terminal buffer",
            pattern = "term://*",
            callback = function()
              local cwd = vim.fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")
              if vim.fn.isdirectory(cwd) == 1 then vim.fn.chdir(cwd) end
            end,
          },
        },

        -- Disables/restores scrolloff for better terminal UX
        terminal_scrolloff = {
          {
            event = "TermEnter",
            desc = "Disable scrolloff in the terminal",
            pattern = "term://*",
            callback = function()
              vim.b.saved_scrolloff = vim.o.scrolloff
              vim.o.scrolloff = 0
            end,
          },
          {
            event = "BufLeave",
            desc = "Restore scrolloff on terminal exit",
            pattern = "term://*",
            callback = function()
              if vim.b.saved_scrolloff ~= nil then vim.o.scrolloff = vim.b.saved_scrolloff end
            end,
          },
        },

        -- Cleaner UI inside the terminal (no numbers/signcolumn)
        terminal_ui = {
          {
            event = "TermOpen",
            desc = "Disable number/relativenumber/signcolumn in terminal buffers",
            pattern = "term://*",
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
            end,
          },
        },
      },

      -- =======================================================================
      -- USER COMMANDS
      -- =======================================================================
      commands = {
        -- Add plugins using pack.lua
        PackAdd = {
          function(opts) vim.pack.add(opts.fargs) end,
          nargs = "+",
          desc = "Add plugins (:PackAdd user/repo1 user/repo2)",
        },

        -- Remove plugins from pack.lua
        PackDel = {
          function(opts) vim.pack.del(opts.fargs) end,
          nargs = "+",
          desc = "Delete plugins (:PackDel plugin1 plugin2)",
        },

        -- Update all plugins or specific ones
        PackUpdate = {
          function(opts)
            if opts.args:match "%S" then
              vim.pack.update(vim.split(opts.args, "%s+", { trimempty = true }))
            else
              vim.pack.update()
            end
          end,
          nargs = "*",
          desc = "Update all plugins or specific ones (:PackUpdate [plugin1 plugin2])",
        },

        -- List non-active plugins and optionally delete them
        PackCheck = {
          function()
            local non_active = vim
              .iter(vim.pack.get())
              :filter(function(x) return not x.active end)
              :map(function(x) return x.spec.name end)
              :totable()

            if #non_active == 0 then
              vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
              return
            end

            vim.print "😴 Non-active plugins :"
            print " "
            for _, name in ipairs(non_active) do
              print(name)
            end
            print " "

            local choice = vim.fn.confirm("Delete ALL non-active plugins from disk?", "&Yes\n&No", 2)

            if choice == 1 then
              vim.pack.del(non_active)
              vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
              print "Non-active plugins deleted!"
              vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
            else
              vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
            end
          end,
          desc = "List non-active plugins and select to delete",
        },

        -- Save macro to file
        SaveMacro = {
          function(params)
            local name = params.args
            local dir = vim.fn.expand "~/.config/nvim/macros/"
            local file = dir .. name .. ".macro"
            local content = vim.fn.getreg "q"

            vim.fn.mkdir(dir, "p")
            vim.fn.writefile({ content }, file, "a")
          end,
          nargs = 1,
          desc = "Save macro from register q to file",
        },

        -- Load macro from file
        LoadMacro = {
          function(params)
            local name = params.args
            local dir = vim.fn.expand "~/.config/nvim/macros/"
            local file = dir .. name .. ".macro"

            local content = vim.fn.readfile(file)
            vim.fn.setreg("q", content)
          end,
          nargs = 1,
          desc = "Load macro from file to register q",
        },

        -- Reload configuration
        Reload = {
          function() vim.cmd ":source $MYVIMRC" end,
          desc = "Reload Neovim configuration",
        },
      },
    },
  },
}
