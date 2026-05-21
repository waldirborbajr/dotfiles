-- require("mason").setup()

-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
-- vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- vim.diagnostic.config({ virtual_text = true })

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

-- vim.lsp.config("*", { capabilities = capabilities })

-- vim.lsp.config("lua_ls", {
--     settings = {
--         Lua = {
--             diagnostics = { globals = { "vim" } },
--         },
--     },
-- })

-- vim.lsp.enable({
--     "lua_ls",
--     "marksman",
--     "gopls",
--     "rust_analyzer",
-- })


require("mason").setup()

-- =========================================================
-- KEYMAPS
-- =========================================================
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
    desc = "Go to definition",
})

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {
    desc = "Format current buffer",
})

vim.keymap.set("n", "df", vim.diagnostic.open_float, {
    desc = "Show line diagnostics",
})

-- =========================================================
-- DIAGNOSTICS
-- =========================================================
vim.diagnostic.config({
    virtual_text = true,
})

-- =========================================================
-- LSP CAPABILITIES
-- =========================================================
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend(
    "force",
    capabilities,
    require("mini.completion").get_lsp_capabilities()
)

vim.lsp.config("*", {
    capabilities = capabilities,
})

-- =========================================================
-- LUA LANGUAGE SERVER
-- =========================================================
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },

    filetypes = { "lua" },

    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".git",
    },

    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },

            diagnostics = {
                globals = { "vim" },

                disable = {
                    "inject-field",
                    "undefined-field",
                    "missing-fields",
                },
            },

            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },

                checkThirdParty = false,
            },

            telemetry = {
                enable = false,
            },
        },
    },
})

-- =========================================================
-- GO LANGUAGE SERVER
-- =========================================================
vim.lsp.config("gopls", {
    cmd = { "gopls" },

    filetypes = {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
    },

    root_markers = {
        "go.mod",
        ".git",
    },
})

-- =========================================================
-- RUST LANGUAGE SERVER
-- =========================================================
vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },

    filetypes = {
        "rust",
    },

    root_markers = {
        "Cargo.toml",
        ".git",
    },
})

-- =========================================================
-- ENABLE SERVERS
-- =========================================================
vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
})
