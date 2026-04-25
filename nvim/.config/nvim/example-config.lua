-- 📝 Ejemplos de Personalización
-- Copia estas secciones a tu init.lua para personalizarlas

-- ============================================================================
-- 1️⃣ CAMBIAR OPCIONES DE EDITOR
-- ============================================================================

-- Número de espacios en indentación
vim.o.tabstop = 4        -- Ancho del tab
vim.o.shiftwidth = 4     -- Indentación con >>
vim.o.softtabstop = 4    -- Espacios del tab al editar

-- Mostrar números de línea
vim.o.number = true
vim.o.relativenumber = true

-- Número máximo de columnas antes de wrappear
vim.o.colorcolumn = "120"

-- Tema de color
vim.cmd.colorscheme "tundra"


-- ============================================================================
-- 2️⃣ AGREGAR NUEVOS ATAJOS PERSONALIZADOS
-- ============================================================================

-- Atajo para ejecutar archivo Python
vim.keymap.set('n', '<leader>rp', function()
  local file = vim.fn.expand('%:p')
  vim.cmd('terminal python3 ' .. file)
end, { desc = 'Run Python file' })

-- Atajo para hacer build
vim.keymap.set('n', '<leader>mb', function()
  vim.cmd('terminal make build')
end, { desc = 'Make build' })

-- Navegar entre split windows con Alt+arrows
vim.keymap.set('n', '<A-Left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Right>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Down>', '<C-w>j', { noremap = true, silent = true })


-- ============================================================================
-- 3️⃣ CAMBIAR OPCIONES DE LSP
-- ============================================================================

-- Deshabilitar diagnosticos virtuales de texto
vim.diagnostic.config({
  virtual_text = false,  -- Mostrar errores solo en el hover
})

-- Cambiar colores de diagnósticos
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#ff6b6b' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#ffd93d' })

-- Habilitar semantic tokens
-- vim.lsp.semantic_tokens.start()


-- ============================================================================
-- 4️⃣ PERSONALIZAR APARIENCIA
-- ============================================================================

-- Cambiar el estilo de la línea de estado
require('lualine').setup({
  options = {
    theme = 'tundra',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
  },
})

-- Cambiar el ancho del explorador
require('neo-tree').setup({
  window = {
    width = 40,  -- Por defecto es 30
  },
})

-- Personalizar notificaciones
require("notify").setup({
  render = "minimal",  -- "default", "minimal", "simple"
  timeout = 3000,      -- Milisegundos antes de desaparecer
})


-- ============================================================================
-- 5️⃣ AGREGAR PLUGINS PERSONALIZADOS
-- ============================================================================

-- En tu vim.pack.add, agrega plugins como:

-- vim.pack.add({
--   { src = "https://github.com/tpope/vim-sensible" },
--   { src = "https://github.com/wellle/targets.vim" },
-- })

-- Luego ejecuta :Lazy sync


-- ============================================================================
-- 6️⃣ CREAR COMANDOS PERSONALIZADOS
-- ============================================================================

-- Comando para cambiar tema rápidamente
vim.api.nvim_create_user_command('Theme', function(opts)
  vim.cmd.colorscheme(opts.args)
end, { nargs = '?' })

-- Uso: :Theme dracula


-- ============================================================================
-- 7️⃣ AUTOCMDS PERSONALIZADOS
-- ============================================================================

-- Auto-formatear al guardar (si tu LSP lo soporta)
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Mostrar errores en una ventana al abrir archivo
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Aquí va tu lógica
  end,
})

-- Auto-guardar cada 5 segundos
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     if vim.bo.modified then
--       vim.cmd('silent write')
--     end
--   end,
-- })


-- ============================================================================
-- 8️⃣ CONFIGURAR TERMINAL INTEGRADA
-- ============================================================================

require("toggleterm").setup({
  direction = "float",           -- "float", "horizontal", "vertical", "tab"
  open_mapping = [[<C-\>]],     -- Atajo para abrir
  insert_mappings = true,
  terminal_mappings = true,
  shade_terminals = true,
  float_opts = {
    border = "rounded",
    width = 0.9,
    height = 0.9,
  },
})

-- Crear atajos para terminales específicas
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set('n', '<leader>gg', '<cmd>lua _lazygit_toggle()<CR>', { desc = 'LazyGit' })


-- ============================================================================
-- 9️⃣ CONFIGURAR TELESCOPE
-- ============================================================================

-- Extender búsquedas de Telescope
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>sc', function()
  telescope.grep_string()
end, { desc = 'Grep word under cursor' })

vim.keymap.set('n', '<leader>st', function()
  telescope.builtin_themes()
end, { desc = 'Builtin themes' })


-- ============================================================================
-- 🔟 CONFIGURAR WHICH-KEY PERSONALIZADO
-- ============================================================================

-- Agregar tu propio grupo en which-key-config.lua:

-- local wk = require("which-key")
-- wk.add({
--   {
--     "<leader>x",
--     group = "Mi Grupo Personalizado",
--     { "<leader>xa", ":MiComando<CR>", desc = "Mi acción" },
--   },
-- })


-- ============================================================================
-- 1️⃣1️⃣ VARIABLES GLOBALES
-- ============================================================================

-- Deshabilitar netrw (si usas neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Cambiar mapleader
-- vim.g.mapleader = ","  -- Por defecto es space

-- Habilitar true color
vim.o.termguicolors = true


-- ============================================================================
-- 1️⃣2️⃣ PERFORMANCE TWEAKS
-- ============================================================================

-- Aumentar updatetime para mejor rendimiento
vim.o.updatetime = 100  -- milliseconds

-- Limitar diagnostics
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
})

-- Deshabilitar algunos plugins si no los usas
-- vim.g.supermaven_disable = true


-- ============================================================================
-- ✨ EJEMPLOS DE SCRIPTS ÚTILES
-- ============================================================================

-- Función para insertar fecha/hora
local function insert_date()
  local date = os.date('%Y-%m-%d %H:%M:%S')
  vim.api.nvim_put({ date }, 'c', true, true)
end

vim.keymap.set('n', '<leader>id', insert_date, { desc = 'Insert date/time' })


-- Función para crear archivo boilerplate
local function create_template(filetype)
  local templates = {
    lua = [[
-- Archivo: ]] .. vim.fn.expand('%:t') .. [[

local function main()
  print("Hello from Lua!")
end

main()
]],
    python = [[
#!/usr/bin/env python3
# Archivo: ]] .. vim.fn.expand('%:t') .. [[

def main():
    print("Hello from Python!")

if __name__ == "__main__":
    main()
]],
  }
  
  if templates[filetype] then
    vim.api.nvim_put(vim.split(templates[filetype], '\n'), 'l', true, true)
  end
end

vim.keymap.set('n', '<leader>nt', function()
  create_template(vim.bo.filetype)
end, { desc = 'New template' })


-- ============================================================================
-- 📚 RECURSOS ÚTILES
-- ============================================================================

-- Documentación de Neovim:
-- :help lua
-- :help api
-- :help options

-- Comunidad:
-- r/neovim
-- GitHub Discussions
-- Neovim Discourse

-- Plugins recomendados para explorar:
-- https://github.com/awesome-neovim/awesome-neovim
