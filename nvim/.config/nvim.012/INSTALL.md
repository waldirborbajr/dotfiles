# 📦 Guía de Instalación

## ⚡ Instalación Rápida (5 minutos)

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/Not-Minimal/notdot.git ~/.config/dotfiles
```

### 2️⃣ Crear enlace simbólico

```bash
# Backup de configuración existente (si existe)
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Crear enlace simbólico
ln -s ~/.config/dotfiles/nvim ~/.config/nvim
```

### 3️⃣ Instalar dependencias

**macOS:**
```bash
brew install neovim ripgrep fd
```

**Arch Linux:**
```bash
sudo pacman -S neovim ripgrep fd
```

**Ubuntu/Debian:**
```bash
sudo apt install neovim ripgrep fd-find
```

**Fedora:**
```bash
sudo dnf install neovim ripgrep fd
```

### 4️⃣ Ejecutar Neovim

```bash
nvim
```

✨ Los plugins se descargarán automáticamente en el primer inicio.

## 🔍 Verificar Instalación

Una vez abierto Neovim, ejecuta:

```vim
:checkhealth
```

Debería mostrar verde en:
- neovim
- clipboard
- python (si lo usas)
- node (si lo usas)

## 🛠️ Instalar LSP Servers

Abre Mason dentro de Neovim:

```vim
:Mason
```

Instala servidores para tus lenguajes favoritos:

```
lua_ls        → Lua
basedpyright  → Python
ts_ls         → TypeScript/JavaScript
rust_analyzer → Rust
tailwindcss   → Tailwind CSS
eslint        → JavaScript/TypeScript linting
emmet_ls      → Emmet (HTML/CSS)
```

Puedes instalarlos directamente:

```vim
:MasonInstall lua_ls basedpyright ts_ls
```

## 📱 Primeros Pasos

### Ver el Dashboard

```vim
:Snacks dashboard
```

### Buscar un archivo

```
<Space><Space>  → Busca archivos rápidamente
```

### Ver estructura del código

```
<leader>lsd  → Símbolos del documento
<leader>lsw  → Símbolos del workspace
```

### Ver todos los atajos

```
Presiona <leader> y espera a que aparezca el menú
```

## ⚙️ Personalización

### Cambiar tema

Edita `~/.config/nvim/init.lua`:

```lua
vim.cmd.colorscheme "tundra"  -- Cambia a otro tema
```

### Agregar nuevos atajos

Edita `~/.config/nvim/lua/config/which-key-config.lua`:

```lua
{
  "<leader>mynew",
  group = "Mi Grupo",
  { "<leader>mynewthing", ":MyCommand<CR>", desc = "Mi acción" },
}
```

### Agregar plugins

En `~/.config/nvim/init.lua`, en la sección `vim.pack.add`:

```lua
vim.pack.add({
  { src = "https://github.com/usuario/plugin.nvim" },
})
```

## 🐛 Solucionar Problemas

### No funciona copiar/pegar

Asegúrate de tener clipboard disponible:

```bash
# macOS
brew install reattach-to-user-namespace

# Linux
sudo apt install xclip  # o xsel
```

### LSP no funciona

1. Verifica que el servidor esté instalado en Mason
2. Ejecuta `:checkhealth` para ver errores
3. Abre un archivo del lenguaje correspondiente

### Los plugins no se descargan

Todos los plugins deben estar ya incluidos. Si hay problemas:

1. Verifica que el enlace simbólico esté correcto:
   ```bash
   ls -la ~/.config/nvim
   ```

2. Revisa los logs:
   ```vim
   :checkhealth
   ```

3. Si es necesario, elimina la carpeta de cache:
   ```bash
   rm -rf ~/.local/share/nvim/site/pack/vim-pack-loader
   nvim
   ```

### Terminal flotante no abre

Verifica que toggleterm esté configurado:

```vim
:ToggleTerm
```

O usa:
```
<leader>t
```

## 🆘 Obtener Ayuda

1. **Ejecuta `:checkhealth`** para diagnósticos
2. **Abre un Issue** en GitHub con:
   - Tu versión de Neovim (`nvim --version`)
   - Tu SO
   - Qué no funciona
   - Pasos para reproducir

## 📝 Actualizar

```bash
cd ~/.config/dotfiles
git pull origin main

# Dentro de Neovim
:Lazy sync
```

## 🎉 ¡Listo!

Ya puedes empezar a usar Neovim. Para más atajos, consulta el [README.md](./README.md).

---

¿Problemas? Abre un issue en [GitHub](https://github.com/Not-Minimal/notdot/issues)
