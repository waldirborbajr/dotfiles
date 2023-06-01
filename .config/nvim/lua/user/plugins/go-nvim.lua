
return {
  {
    "ray-x/go.nvim",
    requires = {  -- optional packages
      "ray-x/guihua.lua",
      -- "neovim/nvim-lspconfig",
      -- "nvim-treesitter/nvim-treesitter",
    },
    opts = {dap_debug = true, dap_debug_gui = true},
    config = function(_, opts) require("go").setup(opts) end,
    -- config = function()
    --   require("go").setup()
    -- end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  }
}
