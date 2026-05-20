-- ============================================================================
-- NEOVIM CONFIGURATION - OPTIMIZED
-- ============================================================================
-- Leader keys, core features, and UI/UX settings
-- Duplicates removed, organized by functional groups, performance-optimized

-- ============================================================================
-- LEADER KEYS
-- ============================================================================
vim.g.mapleader = " "      -- Space as leader for custom mappings
vim.g.maplocalleader = " " -- Space as local leader for buffer-local mappings

-- ============================================================================
-- ENVIRONMENT & FONT DETECTION
-- ============================================================================
vim.g.have_nerd_font = true -- Set true if Nerd Font is installed and active

-- Neovide GUI configuration (if running in Neovide)
if vim.g.neovide then
  local neovide_font_size = 12
  local font_candidates = {
    'MesloLGS NF',
    'JetBrainsMono Nerd Font',
    'JetBrainsMonoNL Nerd Font',
    'FiraCode Nerd Font',
    'Hack Nerd Font',
    'Noto Sans Mono',
    'Monospace',
  }

  local selected_font = font_candidates[#font_candidates]
  -- Attempt to detect installed fonts using fc-list
  if vim.fn.executable('fc-list') == 1 then
    local out = vim.fn.system({ 'fc-list', ':', 'family' })
    for _, font_name in ipairs(font_candidates) do
      if out:find(font_name, 1, true) then
        selected_font = font_name
        break
      end
    end
  else
    -- Fallback to first candidate if fc-list unavailable
    selected_font = font_candidates[1]
  end

  vim.o.guifont = string.format('%s:h%d', selected_font, neovide_font_size)
end

-- ============================================================================
-- DISABLE BUILT-IN PLUGINS & PROVIDERS
-- ============================================================================
vim.g.loaded_netrw = 1       -- Disable netrw file explorer
vim.g.loaded_netrwPlugin = 1 -- Disable netrw plugin component
vim.g.netrw_banner = 0       -- Hide netrw banner (redundant if netrw disabled, kept for safety)

-- Disable unused language providers (silence health check warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ============================================================================
-- DISPLAY & COLORS
-- ============================================================================
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors in terminal
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers (hybrid mode with number=true)
vim.opt.numberwidth = 4       -- Minimum width of number column
vim.opt.signcolumn = "yes:1"  -- Always show sign column (width: 1)
vim.opt.cursorline = false    -- Don't highlight current line (performance)
vim.opt.wrap = false          -- Don't wrap long lines
vim.opt.breakindent = true    -- Wrapped lines preserve indentation
vim.opt.showmode = false      -- Don't show mode in command line (shown in statusline)
vim.opt.showcmd = false       -- Don't show partial command in command line
vim.opt.ruler = true          -- Show cursor position in command line
vim.opt.showtabline = 0       -- Never show tab line
vim.opt.cmdheight = 1         -- Height of command line area
vim.opt.pumheight = 10        -- Max height of popup menu
vim.opt.fillchars = { eob = " " } -- Hide ~ characters on empty lines
vim.o.winborder = "rounded"   -- Rounded borders for floating windows
vim.opt.title = true          -- Set window title to filename
vim.opt.guifont = "monospace:h17" -- Default GUI font (Neovide fallback)

-- ============================================================================
-- EDITOR BEHAVIOR & INTERACTION
-- ============================================================================
vim.opt.mouse = "a"                 -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus"   -- Use system clipboard for yank/paste
vim.opt.confirm = true              -- Prompt for confirmation instead of failing
vim.opt.autoread = true             -- Automatically reload files changed externally
vim.opt.updatetime = 100            -- Time (ms) before CursorHold event (affects plugins)
vim.opt.timeoutlen = 1000           -- Time (ms) to wait for mapped key sequence
vim.opt.conceallevel = 0            -- Show all text normally (no concealment)

-- ============================================================================
-- INDENTATION
-- ============================================================================
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.tabstop = 2        -- Display width of tab character
vim.opt.softtabstop = 2    -- Spaces inserted when pressing Tab
vim.opt.shiftwidth = 2     -- Spaces for each indentation level
vim.opt.smartindent = true -- Auto-indent new lines based on syntax

-- ============================================================================
-- SEARCH
-- ============================================================================
vim.opt.hlsearch = true   -- Highlight all search matches
vim.opt.incsearch = true  -- Show matches while typing
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if pattern contains uppercase
vim.opt.inccommand = "split" -- Preview substitution in split window

-- ============================================================================
-- FILES & BACKUP
-- ============================================================================
vim.opt.fileencoding = "utf-8" -- File encoding for new files
vim.opt.backup = false         -- Don't create backup files
vim.opt.writebackup = false    -- Don't create backup while editing
vim.opt.swapfile = false       -- Don't create swap files
vim.opt.undofile = true        -- Persist undo history between sessions
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Undo directory

-- ============================================================================
-- SPLITS
-- ============================================================================
vim.opt.splitbelow = true -- Open horizontal splits below current window
vim.opt.splitright = true -- Open vertical splits to the right of current window

-- ============================================================================
-- COMPLETION
-- ============================================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion menu options

-- ============================================================================
-- FOLDING (for nvim-ufo plugin)
-- ============================================================================
vim.o.foldenable = true
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldcolumn = "0"

-- ============================================================================
-- UI SPACING
-- ============================================================================
vim.opt.scrolloff = 8 -- Vertical scrolling padding (lines visible below cursor)

-- ============================================================================
-- MISCELLANEOUS
-- ============================================================================
vim.opt.guicursor = ""                -- Disable GUI cursor style customization
vim.opt.isfname:append("@-@")         -- Treat @-@ as part of filename
vim.opt.colorcolumn = "0"             -- Don't show color column (set to "80" to enable)

-- ============================================================================
-- AUTOCMD: HIGHLIGHT YANKING
-- ============================================================================
-- Highlight copied text briefly for visual feedback
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ============================================================================
-- FILETYPE DETECTION (Custom)
-- ============================================================================
vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",  -- Go templates (registered for gopls)
    tmpl = "gotmpl",
  },
  filename = {
    [".envrc"] = "sh",  -- direnv files use bash syntax
  },
  pattern = {
    -- Treat tsconfig/jsconfig files as JSONC (allows comments)
    ["[jt]sconfig.*.json"] = "jsonc",
  },
})