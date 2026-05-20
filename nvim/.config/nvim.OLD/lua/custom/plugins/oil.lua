vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require('oil').setup {
  default_file_explorer = true,
  columns = { 'icon' },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  constrain_cursor = 'editable',
  watch_for_changes = true,
  keymaps = {
    ['g?'] = { 'actions.show_help', mode = 'n' },
    ['<CR>'] = 'actions.select',
    ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-q>'] = { 'actions.close', mode = 'n' },
    ['<C-l>'] = 'actions.refresh',
    ['-'] = { 'actions.parent', mode = 'n' },
    ['_'] = { 'actions.open_cwd', mode = 'n' },
    ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
    ['gx'] = 'actions.open_external',
  },
  use_default_keymaps = true,
  float = { padding = 2, border = 'rounded' },
  preview_win = { update_on_cursor_moved = true, preview_method = 'fast_scratch' },
}

vim.keymap.set('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Open Oil', noremap = true, silent = true })
vim.keymap.set('n', '<leader>-', function() require('oil').toggle_float() end, { desc = 'Open Oil (Float)', noremap = true, silent = true })
