return {
  "stevearc/oil.nvim",
  cmd = { "Oil" },
  init = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require("oil")
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
}
-- return {
--   {
--     "stevearc/oil.nvim",
--     keys = {
--       {
--         "-",
--         "<CMD>Oil --float<CR>",
--         desc = "Open oil.nvim",
--       },
--     },
--     opts = {},
--     -- dependencies = { "nvim-tree/nvim-web-devicons" },
--     dependencies = { "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
--     config = function()
--       require("oil").setup({
--         default_file_explorer = true,
--         delete_to_trash = true,
--         skip_confirm_for_simple_edits = true,
--         view_options = {
--           show_hidden = true,
--           natural_order = true,
--           is_always_hidden = function(name, _)
--             return name == ".." or name == ".git"
--           end,
--         },
--         win_options = {
--           wrap = true,
--         },
--       })
--     end,
--   },
-- }
