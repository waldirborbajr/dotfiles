return {
  {
    "xiyaowong/nvim-transparent",
    event = "VimEnter",
    opts = {
      enable = true,
    },
    config = function()
      vim.cmd([[TransparentEnable]])
    end,
    -- config = function()
    --   require('transparent').setup({
    --     enable = true,
    --   })
    -- end,
  },
}
