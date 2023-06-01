local prefix = "<leader>x"

return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  keys = {
    { prefix,        desc = "Trouble" },
    { prefix .. "q", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
  },
  opts = {
    use_diagnostic_signs = true,
    action_key = {
      close = { "q", "<esc>" },
      cancel = "c-e",
    },
  },
}
