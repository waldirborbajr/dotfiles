local disabled_plugins = {
  "SmiteshP/nvim-navic",
  "echasnovski/mini.diff",
  "echasnovski/mini.surround",
  "echasnovski/mini.indentscope",
  "echasnovski/mini.nvim",
  "folke/neoconf.nvim",
  "ggandor/flit.nvim",
  "ggandor/leap.nvim",
  -- { "mfussenegger/nvim-dap", enabled = false },
  "nvim-neo-tree/neo-tree.nvim",
  "nvim-pack/nvim-spectre",
  "nvim-treesitter/nvim-treesitter-context",
  "simrat39/symbols-outline.nvim",

  "goolord/alpha-nvim",
  "stevearc/dressing.nvim",

  -- lsp/init.lua
  -- lspconfig
  -- { "neovim/nvim-lspconfig", enabled = false },
  -- cmdline tools and lsp servers
  -- { "williamboman/mason.nvim", enabled = false },

  -- coding.lua
  -- auto completion
  -- { "hrsh7th/nvim-cmp", enabled = false },
  -- snippets
  -- { "nvim-cmp", enabled = false },
  -- auto pairs
  -- { "echasnovski/mini.pairs", enabled = false },
  -- comments
  "folke/ts-comments.nvim",
  -- Better text-objects
  "echasnovski/mini.ai",
  "folke/lazydev.nvim",
  -- Manage libuv types with lazy.
  "Bilal2453/luvit-meta",

  -- colorscheme.lua
  -- tokyonight
  "folke/tokyonight.nvim",
  -- catppuccin
  -- { "catppuccin/nvim", enabled = false },

  -- editor.lua
  -- file explorer
  "nvim-neo-tree/neo-tree.nvim",
  -- search/replace in multiple files
  "MagicDuck/grug-far.nvim",
  -- Flash
  "folke/flash.nvim",
  -- which-key
  -- { "folke/which-key.nvim", enabled = false },
  -- git signs
  "lewis6991/gitsigns.nvim",
  -- better diagnostics list and others
  "folke/trouble.nvim",
  -- todo comments
  -- { "folke/todo-comments.nvim", enabled = false },

  -- formatting.lua
  -- { "stevearc/conform.nvim", enabled = false },

  -- linting.lua
  -- { "mfussenegger/nvim-lint", enabled = false },

  -- treesitter.lua
  -- Treesitter
  -- { "nvim-treesitter/nvim-treesitter", enabled = false },
  -- { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  -- Automatically add closing tags for HTML and JSX
  "windwp/nvim-ts-autotag",

  -- ui.lua
  -- Better `vim.notify()`
  "rcarriga/nvim-notify",
  -- bufferline
  "akinsho/bufferline.nvim",
  -- statusline
  -- { "nvim-lualine/lualine.nvim", enabled = false },
  -- indent guides for Neovim
  "lukas-reineke/indent-blankline.nvim",
  -- Highly experimental plugin that completely replaces the UI
  "folke/noice.nvim",
  -- icons
  -- { "echasnovski/mini.icons", enabled = false },
  -- ui components
  "MunifTanjim/nui.nvim",
  "nvimdev/dashboard-nvim",

  -- util.lua
  -- Session management.
  "folke/persistence.nvim",
  -- library used by other plugins
  -- { "nvim-lua/plenary.nvim", enabled = false },
}

local lazy_disabled = {}
for _, plugin in ipairs(disabled_plugins) do
  lazy_disabled[#lazy_disabled + 1] = { plugin, enabled = false }
end

return lazy_disabled
