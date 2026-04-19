return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        local ibl = require("ibl")
        ibl.setup({
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
                show_exact_scope = true, -- pinta la línea completa
                highlight = { "Function", "Label", "Conditional", "Repeat" },
            },
            whitespace = {
                remove_blankline_trail = false, -- hace que siga la línea incluso en líneas vacías
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                    "quickfix",
                    "prompt",
                },
            },
        })
    end,
}


