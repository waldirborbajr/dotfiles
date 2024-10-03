local disabled_plugins = {
  "echasnovski/mini.indentscope",
  "folke/flash.nvim",
  "lazydev.nvim",
  "persistence.nvim",
  "mini.ai",
  "todo-comments.nvim",
  "nvim-notify",
  "noice.nvim",
  "dressing.nvim",
  "ts-comments.nvim",
  "nui.nvim",
  "luvit-meta",
  "neo-tree.nvim",
  "render-markdown.nvim",
  "tokionight.nvim",
}

local lazy_disabled = {}
for _, plugin in ipairs(disabled_plugins) do
  lazy_disabled[#lazy_disabled + 1] = { plugin, enabled = false }
end

return lazy_disabled
