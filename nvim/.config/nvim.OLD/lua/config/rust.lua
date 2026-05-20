vim.g.rustaceanvim = {
  server = {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = true,
          experimental = { enable = true },
        },
        checkOnSave = true,
        check = {
          command = 'clippy',
        },
      },
    },
  },
}
