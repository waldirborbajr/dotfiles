return {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
  --     config = function()
  -- require("notify").setup({
  --       background_colour = "#000000",
  --     })
    }
    }
