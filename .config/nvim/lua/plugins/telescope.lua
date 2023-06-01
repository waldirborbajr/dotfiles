return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    config = function(_, opts)
      local t = require("telescope")
      t.setup(opts)
      t.load_extension("ui-select")
      t.load_extension("fzf")
    end,
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Commands" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",    desc = "Keymaps" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Bufferlist" },
      {
        "<leader>H",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
    },
  },
}
