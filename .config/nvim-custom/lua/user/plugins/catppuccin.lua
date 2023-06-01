return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cmd = { "Catppuccin" },
    lazy = false,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
        integrations = {
          treesitter = true,
          lsp_trouble = true,
          cmp = true,
          lsp_saga = true,
          gitsigns = true,
          notify = true,
          symbols_outline = true,
          fidget = true,
          mini = true,
          telescope = true,
        },
      })
      -- vim.g.catppuccin_flavour = "latte" -- latte, frappe, macchiato, mocha
      vim.cmd([[colorscheme catppuccin-frappe]])
    end,
  },

}
