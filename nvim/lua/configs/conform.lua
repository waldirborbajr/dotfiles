local options = {
  formatters_by_ft = {
    -- css = { "prettier" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    -- html = { "prettier" },
    -- javascript = { "biome" },
    -- json = { "biome" },
    -- python = { "ruff" },
    -- typescript = { "biome" },
    -- tyspt = { "typstyle" },
    -- yaml = { "rubocop" },
    bash = { "shfmt" },
    latex = { "latexindent" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
