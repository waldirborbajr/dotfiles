-- [[ Configure and install plugins with `vim.pack` ]]
--
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()
--
-- NOTE: Here is where you install your plugins.
local gh = function(repo) return 'https://github.com/' .. repo end

local run_build = function(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make' }, ev.data.path)
      return
    end

    if name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
      return
    end
  end,
})

---@type (string|vim.pack.Spec)[]
local plugins = {
  gh 'NMAC427/guess-indent.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh 'folke/which-key.nvim',
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'j-hui/fidget.nvim',
  gh 'stevearc/conform.nvim',
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  gh 'EdenEast/nightfox.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'nvim-mini/mini.nvim',
  { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '^9' },
  gh 'christoomey/vim-tmux-navigator',
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'windwp/nvim-autopairs',
  { src = gh 'nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  gh 'MunifTanjim/nui.nvim',
  gh 'lukas-reineke/indent-blankline.nvim',
  gh 'mfussenegger/nvim-lint',
}

if vim.fn.executable 'make' == 1 then table.insert(plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

-- Useful for getting pretty icons, but requires a Nerd Font.
if vim.g.have_nerd_font then table.insert(plugins, gh 'nvim-tree/nvim-web-devicons') end

vim.pack.add(plugins)

-- Snippet Engine
--
-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
-- require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').setup {}

-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
-- require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.indent_line'
-- require 'kickstart.plugins.lint'
-- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

require 'config.plugins'
--
-- For additional information with loading, sourcing and examples see `:help vim.pack`
-- and `:help vim.pack-examples`

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
