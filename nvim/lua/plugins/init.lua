return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  },

  { "echasnovski/mini.icons", version = false },

  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    init = function()
      if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
        require "oil"
      end
    end,
    opts = {
      keymaps = {
        ["q"] = "actions.close",
        ["<C-h>"] = "actions.toggle_hidden",
        [".."] = "actions.parent",
      },
    },
    keys = {
      { "<leader>o", "<CMD>Oil<CR>", desc = "Open Oil" },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "vim",
  --       "lua",
  --       "vimdoc",
  --       -- "html", "css"
  --     },
  --   },
  -- },
}
