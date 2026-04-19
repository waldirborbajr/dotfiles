return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        -- Configuración sencilla para nvim-notify
        require("notify").setup({
            stages = "static", -- animación simple
            timeout = 2500, -- duración del mensaje en ms
            top_down = true, -- los mensajes nuevos van arriba
        })

        -- Configuración básica de noice.nvim
        require("noice").setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                progress = {
                    enabled = true,
                    format = {
                        "{spinner} {title}",
                    },
                },
            },
            routes = {
                {
                    filter = {
                        event = "lsp",
                        kind = "progress",
                    },
                    view = "mini",
                    opts = {
                        replace = true,
                        transform = function(message)
                            -- texto corto fijo
                            message.title = "Cargando"
                            message.message = ""
                            message.percentage = nil
                            return message
                        end,
                    },
                },
            },
            presets = {
                bottom_search = false, -- línea de búsqueda abajo
                command_palette = true, -- cmdline como paleta de comandos
                long_message_to_split = true, -- divide mensajes largos
                inc_rename = false,
                lsp_doc_border = false,
            },
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                opts = {},
                format = {
                    search_down = {
                        view = "cmdline_popup", -- popup para /
                        kind = "search",
                        opts = {
                            position = { row = 5, col = "50%" },
                            size = { width = 60, height = "auto" },
                            border = { style = "rounded" },
                            win_options = { winblend = 10 },
                        },
                    },
                    search_up = {
                        view = "cmdline_popup", -- popup para ?
                        kind = "search",
                        opts = {
                            position = { row = 5, col = "50%" },
                            size = { width = 60, height = "auto" },
                            border = { style = "rounded" },
                            win_options = { winblend = 10 },
                        },
                    },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5, -- fila 5 desde arriba
                        col = "50%", -- centrado horizontalmente
                    },
                    size = {
                        width = 60, -- ancho del cuadro
                        height = "auto",
                    },
                    border = {
                        style = "rounded", -- borde redondeado
                    },
                    win_options = {
                        winblend = 10, -- transparencia (opcional)
                    },
                },
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
            },
            messages = {
                enabled = true,
            },
            notify = {
                enabled = true,
            },
        })
    end,
}

