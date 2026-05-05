# 🚀 Neovim 0.12.1+ Dotfiles

Configuración moderna y minimalista de Neovim para programadores que usan Lua. Incluye LSP completo, dashboard personalizado, y atajos de teclado organizados con which-key.

<div align="center">

![Neovim Version](https://img.shields.io/badge/neovim-0.12.1+-green)
![Language](https://img.shields.io/badge/language-lua-blue)
![License](https://img.shields.io/badge/license-MIT-green)

</div>

## ✨ Características Principales

- **Dashboard Personalizado** - Inicio rápido con snacks.nvim
- **LSP Completo** - Soporte para múltiples lenguajes (TypeScript, Python, Rust, Lua, etc.)
- **Keybindings Organizados** - Menú jerárquico con which-key.nvim
- **Gestor de Imports** - Organizar, agregar y quitar imports automáticamente
- **Símbolos de Código** - Visualizar structure del código con pickers interactivos
- **Diagnósticos Mejorados** - Navegación y visualización clara de errores
- **Tema Moderno** - Tema Tundra oscuro y minimalista
- **Rendimiento** - Startup rápido con configuración optimizada

## 📋 Requisitos

- **Neovim** >= 0.12.1
- **Git**
- **ripgrep** - Para búsquedas rápidas
- **fd** - Para encontrar archivos
- **Nerd Font** (opcional, recomendado para iconos)

### Instalación de Dependencias

```bash
# macOS
brew install neovim ripgrep fd

# Arch Linux
sudo pacman -S neovim ripgrep fd

# Ubuntu/Debian
sudo apt install neovim ripgrep fd-find
```

## 🚀 Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/Not-Minimal/notdot.git ~/.config/dotfiles

# 2. Crear enlace simbólico para nvim
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

# 3. Abrir Neovim
nvim
```

Todos los plugins y configuraciones están listos para usar.

## 📦 Plugins Instalados

### UI & Tema
- **snacks.nvim** - Dashboard y utilidades
- **nvim-tundra** - Tema oscuro minimalista
- **lualine.nvim** - Barra de estado personalizada
- **nvim-web-devicons** - Iconos para archivos

### Navegación
- **neo-tree.nvim** - Explorador de archivos avanzado
- **telescope.nvim** - Fuzzy finder poderoso
- **oil.nvim** - Gestor de archivos estilo buffers
- **mini.files** - Minigestor de archivos

### LSP & Autocompletado
- **nvim-lspconfig** - Configuración LSP nativa (Neovim 0.12+)
- **mason.nvim** - Gestor de LSP servers
- **mason-lspconfig.nvim** - Integración Mason + LSP
- **blink.cmp** - Autocompletado ultrarrápido
- **nvim-notify** - Notificaciones mejoradas

### Edición & Refactoring
- **conform.nvim** - Formatting automático
- **tiny-inline-diagnostic.nvim** - Diagnósticos en línea
- **which-key.nvim** - Menú de keybindings
- **toggleterm.nvim** - Terminal flotante integrada

### Git
- **diffview.nvim** - Visor de diffs mejorado

### Otros
- **vim-wakatime** - Tracking de tiempo
- **supermaven-nvim** - Autocompletado IA (opcional)

## ⌨️ Atajos de Teclado

### Navegación Rápida
```
K              → Información hover (LSP)
<C-k>          → Signature help (parámetros de función)
gd             → Ir a definición
```

### 🔍 Búsqueda (Leader + S)
```
<leader>s      → Abre menú de búsqueda
  sf           → Buscar archivos
  sg           → Grep en código
  sb           → Buffers abiertos
  sh           → Páginas de ayuda
```

### 📁 Archivos (Leader + F)
```
<leader>f      → Abre menú de archivos
  ff           → Buscar archivo
  fr           → Archivos recientes
  fn           → Nuevo archivo
```

### 🛠️ LSP - Navegación (Leader + L + N)
```
<leader>ln     → Abre menú de navegación
  d            → Ir a definición
  D            → Ir a declaración
  i            → Ir a implementación
  r            → Ver referencias
  t            → Ir a definición de tipo
```

### 🔧 LSP - Refactoring (Leader + L + R)
```
<leader>lr     → Abre menú de refactoring
  n            → Renombrar símbolo
  a            → Code actions
  f            → Formatear buffer
```

### 📦 LSP - Imports (Leader + L + I)
```
<leader>li     → Abre menú de imports
  o            → Organizar imports (quitar no usados + agregar faltantes)
  u            → Quitar imports no usados
  m            → Agregar imports faltantes
```

### 🗂️ LSP - Símbolos (Leader + L + S)
```
<leader>ls     → Abre menú de símbolos
  d            → Símbolos del documento (outline)
  w            → Símbolos del workspace
```

### 📞 LSP - Llamadas (Leader + L + C)
```
<leader>lc     → Abre menú de llamadas
  i            → Llamadas entrantes
  o            → Llamadas salientes
```

### 🐛 LSP - Diagnósticos (Leader + L + D)
```
<leader>ld     → Abre menú de diagnósticos
  o            → Abrir diagnostic flotante
  p            → Diagnóstico anterior
  n            → Siguiente diagnóstico
  a            → Ver todos los diagnósticos
  b            → Diagnósticos del buffer
```

### ❓ LSP - Ayuda (Leader + L + H)
```
<leader>lh     → Abre menú de ayuda
  h            → Información hover
  s            → Signature help
```

### 🖥️ Workspace (Leader + W)
```
<leader>w      → Abre menú de workspace
  f            → Gestor de archivos (Oil)
  t            → Toggle terminal
  T            → Matar terminal
```

### 📂 Explorador & Terminal
```
<leader>e      → Toggle Neo-tree (explorador de archivos)
<leader>t      → Toggle terminal flotante
<leader>T      → Cerrar terminal completamente
<Space><Space> → Buscar archivos rápido
```

### 🎯 Salir (Leader + Q)
```
<leader>q      → Abre menú de salida
  q            → Quit All
  w            → Write & Quit All
```

## 🎨 Personalizando

### Cambiar Tema
Edita `init.lua`:
```lua
vim.cmd.colorscheme "tundra"  -- Cambia a otro tema
```

### Agregar Nuevos LSP Servers
```lua
-- En init.lua, busca 'ensure_installed' en mason-lspconfig
ensure_installed = { "lua_ls", "basedpyright", "rust_analyzer", ... }
```

Luego instala en Neovim:
```vim
:Mason
```

### Modificar Keybindings
Edita `/lua/config/which-key-config.lua` para cambiar atajos.

## 🏗️ Estructura de Carpetas

```
~/.config/nvim/
├── init.lua                          # Archivo principal
├── nvim-pack-lock.json               # Lock file de plugins
└── lua/
    └── config/
        └── which-key-config.lua      # Configuración de atajos
```

## 🔧 Primeros Pasos

1. **Abre Neovim**:
   ```bash
   nvim
   ```

2. **Instala LSP Servers** (opcional pero recomendado):
   ```vim
   :Mason
   ```
   Instala servidores para tus lenguajes favoritos.

3. **Verifica la salud**:
   ```vim
   :checkhealth
   ```

4. **Abre el Dashboard**:
   ```vim
   :Snacks dashboard
   ```

## 📚 Guía de Uso

### Buscar Archivos
- `<Space><Space>` - Búsqueda rápida de archivos
- `<leader>sf` - Buscar en archivos del proyecto

### Ver Estructura del Código
- `<leader>lsd` - Ver outline del documento actual
- `<leader>lsw` - Ver símbolos de todo el workspace

### Organizar Imports
```
<leader>lio     → Organiza imports (quita no usados, agrega faltantes)
<leader>liu     → Solo quita imports no usados
<leader>lim     → Solo agrega imports faltantes
```

### Diagnosticos
- `<leader>lda` - Ver todos los problemas
- `[d` / `]d` - Navegar entre errores

### Terminal Integrada
- `<leader>t` - Abre/cierra terminal flotante
- `<C-\>` - Alternativamente (toggleterm)

## 🤝 Contribuir

¿Tienes mejoras? ¡Pull requests bienvenidos!

1. Fork el repo
2. Crea una rama (`git checkout -b feature/mi-mejora`)
3. Commit cambios (`git commit -am 'Agregar mi mejora'`)
4. Push a la rama (`git push origin feature/mi-mejora`)
5. Abre un Pull Request

## 📝 Licencia

MIT - Libre para usar y modificar

## 🎓 Aprende Más

- [Neovim Docs](https://neovim.io/doc/user/)
- [Lua en Neovim](https://neovim.io/doc/user/lua.html)
- [LSP](https://microsoft.github.io/language-server-protocol/)
- [Which-key.nvim](https://github.com/folke/which-key.nvim)
- [Snacks.nvim](https://github.com/folke/snacks.nvim)

---

**¿Dudas?** Abre un issue en el repositorio.

¡Feliz coding! 🚀
