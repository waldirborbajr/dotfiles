# 🤝 Contribuir a notdot Neovim Config

¡Gracias por querer mejorar esta configuración! Aquí está cómo contribuir.

## 🐛 Reportar Bugs

Abre un issue describiendo:

1. **Tu entorno**: Neovim version, SO, plugins instalados
2. **El problema**: qué no funciona
3. **Pasos para reproducir**: instrucciones claras
4. **Comportamiento esperado**: qué debería pasar
5. **Logs/Screenshots**: si aplica

## 🚀 Sugerir Mejoras

Abre un issue con:

1. **Descripción clara** de la mejora
2. **Por qué** sería útil
3. **Ejemplos** si aplica
4. **Links** a plugins/configuraciones similares

## 💻 Enviar Pull Request

### Setup

```bash
# 1. Fork el repo
git clone https://github.com/tu-usuario/notdot.git
cd notdot

# 2. Crea una rama
git checkout -b feature/mi-mejora
```

### Hacer cambios

1. Edita los archivos
2. Prueba en tu Neovim local:
   ```bash
   ln -s $(pwd)/nvim ~/.config/nvim.test
   NVIM_APPNAME=nvim.test nvim
   ```
3. Verifica que no hay errores:
   ```vim
   :checkhealth
   ```

### Commit

```bash
# Commit con mensajes descriptivos
git commit -m "feat: agregar nueva funcionalidad"
git commit -m "fix: corregir bug en imports"
git commit -m "docs: actualizar README"
```

**Formatos de mensajes**:
- `feat:` - Nueva funcionalidad
- `fix:` - Corrección de bug
- `docs:` - Cambios de documentación
- `refactor:` - Refactorización de código
- `style:` - Cambios de formato/estilos
- `test:` - Agregando tests

### Push & PR

```bash
git push origin feature/mi-mejora
```

Luego abre un Pull Request en GitHub con:

1. **Título descriptivo**
2. **Descripción** de qué cambios hace
3. **Motivación** - por qué es útil
4. **Testing** - cómo lo probaste
5. **Screenshots** si aplica

## 📋 Checklist

Antes de hacer commit:

- [ ] El código funciona localmente
- [ ] No hay errores de sintaxis Lua
- [ ] Atajos no colisionan con existentes
- [ ] Documentación actualizada si aplica
- [ ] Commit messages son claros

## 📚 Estándares de Código

### Lua Style

```lua
-- Usa 2 espacios de indentación
local config = {
  enabled = true,
  timeout = 5000,
}

-- Funciones descriptivas
local function toggle_terminal()
  -- ...
end

-- Documentación clara
-- Abre el terminal flotante
vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle terminal' })
```

### Keybindings

Sigue la estructura jerárquica en `which-key-config.lua`:

```lua
{
  "<leader>new",
  group = "New Group",
  { "<leader>newf", action, desc = "First action" },
  { "<leader>news", action, desc = "Second action" },
}
```

### Plugins

Si agregas un plugin nuevo:

1. Agrégalo a `init.lua` en la sección apropriada
2. Comenta para qué sirve
3. Actualiza el README
4. Asegúrate de seguir los estándares de código

## 🎯 Áreas de Contribución

### Bienvenidas

- Nuevos keybindings LSP
- Mejoras de rendimiento
- Better themes support
- Documentación mejorada
- Traducción a otros idiomas

### Por Favor NO

- Agregar plugins sin consultar primero
- Cambiar keybindings existentes sin motivo
- Dependencias no necesarias
- Configuraciones específicas de usuario

## ❓ Preguntas?

Abre una Discussion o un Issue.

---

¡Gracias por contribuir! 🚀
