local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    bash = { "shfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    -- javascript = { "biome" },
    -- json = { "biome" },
    latex = { "latexindent" },
    nix = { "nixfmt" },
    -- python = { "ruff" },
    terraform = { "terraform_fmt" },
    toml = { "taplo" },
    -- typescript = { "biome" },
    -- tyspt = { "typstyle" },
    -- yaml = { "rubocop" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
