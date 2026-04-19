local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.mouse = "a"
opt.laststatus = 3
opt.scrolloff = 8

-- colores verdaderos
opt.termguicolors = true

-- fondo oscuro
opt.background = "dark"

-- No plegar lineas
opt.foldenable = false
opt.foldmethod = "syntax"
opt.foldlevelstart = 99

-- Búsqueda
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true

-- Indentación
opt.autoindent = true
opt.smartindent = false
opt.expandtab = true

-- Tabulaciones
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Ajustes de línea
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Opciones generales
opt.errorbells = false
opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.backspace = { "start", "eol", "indent" }

-- Portapapeles
opt.clipboard = "unnamedplus"

-- adicionales
opt.splitright = true -- Dividir ventanas a la derecha
opt.splitbelow = true -- Dividir ventanas abajo

-- Desactivar el ShaDa
opt.shada = ""
opt.shadafile = "NONE"

