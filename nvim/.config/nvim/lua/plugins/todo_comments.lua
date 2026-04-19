return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- opts = {
        --   -- your configuration comes here
        --   -- or leave it empty to use the default settings
        --   -- refer to the configuration section below
        -- },
        config = function()
            require("todo-comments").setup({
                signs = true,
                sign_priority = 8,

                -- keywords = {
                    -- 	FIX = {
                        -- 		icon = " ",
                        -- 		color = "error",
                        -- 		alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                        -- 	},
                        -- 	TODO = { icon = " ", color = "todo" },
                        -- 	HACK = { icon = "󰈸 ", color = "hack" },
                        -- 	WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                        -- 	PERF = { icon = "󱐋 ", color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                        -- 	INFO = { icon = "󰋼 ", color = "info", alt = { "INFO" } },
                        -- 	TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                        -- },

                        keywords = {
                            FIX = {
                                icon = " ",
                                color = "error",
                                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                            },

                            TODO = {
                                icon = " ",
                                color = "todo",
                            },

                            HACK = {
                                icon = "󰈸 ",
                                color = "hack",
                            },

                            WARN = {
                                icon = " ",
                                color = "warning",
                                alt = { "WARNING", "XXX" },
                            },

                            PERF = {
                                icon = "󱐋 ",
                                color = "perf",
                                alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
                            },

                            INFO = {
                                icon = "󰋼 ",
                                color = "info",
                            },

                            TEST = {
                                icon = " ",
                                color = "test",
                                alt = { "TESTING", "PASSED", "FAILED" },
                            },
                        },

                        gui_style = {
                            fg = "NONE", -- The gui style to use for the fg highlight group.
                            bg = "BOLD", -- The gui style to use for the bg highlight group.
                        },
                        merge_keywords = true,

                        highlight = {
                            comments_only = true,
                            keyword = "wide_bg",
                            before = "",
                            after = "",
                            multiline = false,
                            max_line_len = 300,
                        },

                        -- colors = {
                            -- 	error = { "DiagnosticError", "#DC2626" },
                            -- 	todo = { "Dia" },
                            -- 	info = { "DiagnosticInfo", "#3A506B" },
                            -- 	hack = { "DiagnosticHack", "#5E8C61" },
                            -- 	warning = { "DiagnosticWarn", "#FBBF24" },
                            -- 	perf = { "IdentifierPerf", "#8C6057" },
                            -- 	hint = { "DiagnosticHint", "#EAE0D5" },
                            -- 	test = { "IdentifierTest", "#693668" },
                            -- },
                            colors = {
                                error = { "#f38ba8" }, -- FIX / rojo pastel
                                warning = { "#f9e2af" }, -- WARN / amarillo pastel
                                info = { "#74c7ec" }, -- INFO / cyan pastel
                                hint = { "#b4befe" }, -- lavanda pastel (reemplaza el gris)

                                todo = { "#89b4fa" }, -- TODO / azul pastel
                                hack = { "#a6e3a1" }, -- HACK / verde pastel
                                perf = { "#fab387" }, -- PERF / naranja pastel
                                test = { "#cba6f7" }, -- TEST / morado pastel
                            },

                            search = {
                                command = "rg",
                                pattern = [[\b(KEYWORDS):]],
                            },
                        })
                    end,
                }

