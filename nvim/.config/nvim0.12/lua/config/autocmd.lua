-- =============================================================================
-- AUTOCOMMANDS (versão unificada)
-- =============================================================================
-- Autocmds são carregados automaticamente no evento VeryLazy.
-- Arquivo consolidado: duplicações removidas, regras conflitantes resolvidas
-- e alguns autocmds novos adicionados (ver relatório enviado junto do arquivo).

local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- =============================================================================
-- PERFORMANCE / GERAL
-- =============================================================================

-- Verifica se o arquivo mudou fora do Neovim (debounced)
local _checktime_timer = nil
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  desc = "Checar mudanças externas no arquivo (debounced)",
  callback = function()
    if _checktime_timer then
      _checktime_timer:stop()
      _checktime_timer:close()
      _checktime_timer = nil
    end
    _checktime_timer = vim.defer_fn(function()
      _checktime_timer = nil
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end, 200)
  end,
})

-- Redimensiona splits proporcionalmente quando a janela do terminal muda
local _resize_timer = nil
autocmd("VimResized", {
  group = augroup("resize_splits"),
  desc = "Reequilibrar splits ao redimensionar a janela (debounced)",
  callback = function()
    if _resize_timer then
      _resize_timer:stop()
      _resize_timer:close()
      _resize_timer = nil
    end
    local current_tab = vim.fn.tabpagenr()
    _resize_timer = vim.defer_fn(function()
      _resize_timer = nil
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end, 100)
  end,
})

-- [NOVO] Desativa recursos pesados em arquivos muito grandes (>1MB)
autocmd("BufReadPre", {
  group = augroup("large_file"),
  desc = "Desativar swapfile, spell, folds e treesitter em arquivos grandes",
  callback = function(event)
    local name = vim.api.nvim_buf_get_name(event.buf)
    local ok, stats = pcall(function()
      return vim.uv.fs_stat(name)
    end)
    if ok and stats and stats.size > 1024 * 1024 then
      vim.b[event.buf].large_file = true
      vim.bo[event.buf].swapfile = false
      vim.opt_local.spell = false
      vim.opt_local.foldmethod = "manual"
      vim.schedule(function()
        pcall(vim.treesitter.stop, event.buf)
      end)
    end
  end,
})

-- =============================================================================
-- BUFFER & CURSOR
-- =============================================================================

-- Restaura a última posição do cursor ao reabrir um arquivo
-- (une "last_loc" e "last_location": guarda de filetype + centraliza a tela)
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  desc = "Restaurar última posição do cursor",
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.cmd, [[normal! g`"zz]])
    end
  end,
})

-- Cria diretórios intermediários automaticamente ao salvar, se não existirem
autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  desc = "Criar diretório de destino automaticamente ao salvar",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- =============================================================================
-- UI / EXPERIÊNCIA DE EDIÇÃO
-- =============================================================================

-- Melhora performance visual durante inserção (desliga cursorline/relativenumber)
autocmd("InsertEnter", {
  group = augroup("insert_ui_perf"),
  desc = "Simplificar UI ao entrar no modo de inserção",
  callback = function()
    vim.wo.cursorline = false
    vim.wo.relativenumber = false
    vim.wo.number = true
  end,
})

autocmd("InsertLeave", {
  group = augroup("insert_ui_perf"),
  desc = "Restaurar UI ao sair do modo de inserção",
  callback = function()
    vim.wo.cursorline = true
    vim.wo.relativenumber = true
  end,
})

-- Trata "-" como parte da palavra em CSS/HTML/JSX etc. (útil p/ classes kebab-case)
autocmd("FileType", {
  group = augroup("iskeyword_kebab"),
  desc = "Incluir '-' em iskeyword para arquivos baseados em kebab-case",
  pattern = { "css", "scss", "less", "html", "htmldjango", "blade", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})

-- Destaca o texto copiado (yank) por um curto período
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Destacar visualmente o texto copiado",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Corrige o conceallevel em arquivos JSON (evita esconder aspas/chaves)
autocmd("FileType", {
  group = augroup("json_conceal"),
  desc = "Desativar conceal em arquivos JSON",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- =============================================================================
-- FILETYPES ESPECIAIS (fechar, indentação, detecção)
-- =============================================================================

-- Fecha alguns tipos de buffer com "q" e os remove da lista de buffers
autocmd("FileType", {
  group = augroup("close_with_q"),
  desc = "Fechar buffers utilitários com 'q'",
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Ajustes para páginas de manual (une "man_unlisted" + "man_page_indent")
autocmd("FileType", {
  group = augroup("man_settings"),
  desc = "Buffer de man page não listado + indentação estreita",
  pattern = "man",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.bo[event.buf].shiftwidth = 1
    vim.bo[event.buf].tabstop = 1
  end,
})

-- Wrap, linebreak e spellcheck para arquivos de "prosa"
-- (une "wrap_spell" x2 + "wrap_spell" alternativo + "BetterReadForTextFiles")
autocmd("FileType", {
  group = augroup("wrap_spell"),
  desc = "Ativar wrap, linebreak e spell em arquivos de texto/markdown",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Garante que .md/.mdx sejam detectados como markdown
-- (versão anterior duplicava wrap/linebreak/nospell, conflitando com "wrap_spell")
autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  group = augroup("markdown_filetype"),
  desc = "Detectar .md/.mdx como markdown",
  pattern = { "*.md", "*.mdx" },
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- Corrige syntax highlighting em buffers especiais
autocmd("FileType", {
  group = augroup("syntax_highlighting_fix"),
  desc = "Corrigir syntax highlighting em buffers especiais",
  pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth", "less" },
  callback = function(event)
    vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
  end,
})

-- keywordprg para arquivos Vimscript (busca na :help)
autocmd("FileType", {
  group = augroup("vim_help_lookup"),
  desc = "Usar :help como keywordprg em arquivos Vim",
  pattern = "vim",
  command = "setlocal keywordprg=:vert\\ help",
})

-- Usa tabs reais (não espaços) para Go e Rust
autocmd("FileType", {
  group = augroup("tab_for_indent"),
  desc = "Usar hard tabs em Go e Rust",
  pattern = { "go", "rust" },
  callback = function()
    vim.bo.expandtab = false
  end,
})

-- Define filetype para .env e .env.*
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("env_filetype"),
  desc = "Definir filetype=sh para arquivos .env",
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- Define filetype para arquivos *.tomg-config*
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("toml_filetype"),
  desc = "Definir filetype=toml para *.tomg-config*",
  pattern = { "*.tomg-config*" },
  callback = function()
    vim.opt_local.filetype = "toml"
  end,
})

-- Define filetype para arquivos .ejs
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("ejs_filetype"),
  desc = "Definir filetype=embedded_template para .ejs",
  pattern = { "*.ejs", "*.ejs.t" },
  callback = function()
    vim.opt_local.filetype = "embedded_template"
  end,
})

-- Define filetype para arquivos .code-snippets
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("code_snippets_filetype"),
  desc = "Definir filetype=json para .code-snippets",
  pattern = { "*.code-snippets" },
  callback = function()
    vim.opt_local.filetype = "json"
  end,
})

-- =============================================================================
-- COMENTÁRIOS
-- =============================================================================

-- Desativa continuação automática de comentários em novas linhas
autocmd({ "FileType", "BufEnter" }, {
  group = augroup("no_auto_comment"),
  desc = "Desativar continuação automática de comentários",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- =============================================================================
-- EDIÇÃO DE TEXTO
-- =============================================================================

-- Remove espaços em branco no final das linhas ao salvar
-- (melhoria: ignora filetypes onde trailing whitespace é significativo,
-- como markdown, que usa 2 espaços no final para forçar quebra de linha)
autocmd("BufWritePre", {
  group = augroup("remove_trailing_whitespace"),
  desc = "Remover trailing whitespace ao salvar (exceto markdown/diff)",
  callback = function(event)
    local exclude = { "markdown", "diff" }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Corrige automaticamente com `oxlint --fix` ao salvar, se o projeto tiver config
local function root_has_oxlint(path)
  return vim.fs.find({
    ".oxlintrc.json",
    ".oxlintrc.jsonc",
    "oxlint.config.ts",
  }, {
    upward = true,
    path = path,
    stop = vim.loop.os_homedir(),
  })[1] ~= nil
end

autocmd("BufWritePre", {
  group = augroup("oxlint_fix_on_save"),
  desc = "Rodar oxlint --fix ao salvar (se configurado no projeto)",
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
  callback = function(args)
    local path = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))
    if not root_has_oxlint(path) then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "oxlint" })
    if #clients == 0 then
      return
    end

    clients[1]:request_sync("workspace/executeCommand", {
      command = "oxc.fixAll",
      arguments = {
        {
          uri = vim.uri_from_bufnr(args.buf),
          version = vim.lsp.util.buf_versions[args.buf],
        },
      },
    }, 1000, args.buf)
  end,
})

-- Formatação ao salvar via efm-langserver (opcional, desativado por padrão)
-- local lsp_fmt_group = augroup("format_on_save")
-- autocmd("BufWritePre", {
--   group = lsp_fmt_group,
--   callback = function()
--     require("mini.trailspace").trim()
--     local efm = vim.lsp.get_clients({ name = "efm" })
--     if vim.tbl_isempty(efm) then
--       return
--     end
--     vim.lsp.buf.format({ name = "efm", async = true })
--   end,
-- })

-- =============================================================================
-- TREE-SITTER
-- =============================================================================

-- Inicia o Tree-sitter automaticamente via API nativa
autocmd("FileType", {
  group = augroup("treesitter_start"),
  desc = "Iniciar Tree-sitter automaticamente",
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
})

-- =============================================================================
-- FOLDS & DISPLAY
-- =============================================================================

-- Abrir todos os folds automaticamente (opcional, desativado por padrão)
-- autocmd("BufEnter", {
--   group = augroup("open_folds"),
--   desc = "Abrir todos os folds ao entrar no buffer",
--   command = "silent! normal! zR",
-- })

-- =============================================================================
-- TERMINAL
-- =============================================================================

-- Sincroniza o cwd do Neovim com o diretório do processo do terminal
autocmd({ "BufEnter", "TermEnter", "TermLeave" }, {
  group = augroup("terminal_cwd_sync"),
  desc = "Sincronizar cwd com o buffer do terminal",
  pattern = "term://*",
  callback = function()
    local cwd = vim.fn.resolve("/proc/" .. vim.b.terminal_job_pid .. "/cwd")
    if vim.fn.isdirectory(cwd) == 1 then
      vim.fn.chdir(cwd)
    end
  end,
})

-- Desativa scrolloff dentro do terminal para melhor UX
autocmd("TermEnter", {
  group = augroup("terminal_scrolloff"),
  desc = "Desativar scrolloff no terminal",
  pattern = "term://*",
  callback = function()
    vim.b.saved_scrolloff = vim.o.scrolloff
    vim.o.scrolloff = 0
  end,
})

-- Restaura o scrolloff ao sair do terminal
autocmd("BufLeave", {
  group = augroup("terminal_scrolloff_restore"),
  desc = "Restaurar scrolloff ao sair do terminal",
  pattern = "term://*",
  callback = function()
    if vim.b.saved_scrolloff ~= nil then
      vim.o.scrolloff = vim.b.saved_scrolloff
    end
  end,
})

-- [NOVO] UI mais limpa dentro do terminal (sem números/signcolumn)
autocmd("TermOpen", {
  group = augroup("terminal_ui"),
  desc = "Desativar number/relativenumber/signcolumn em buffers de terminal",
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- =============================================================================
-- USER COMMANDS
-- =============================================================================

-- Adicionar plugins usando pack.lua
vim.api.nvim_create_user_command("PackAdd", function(opts)
  vim.pack.add(opts.fargs)
end, {
  nargs = "+",
  desc = "Add plugins (:PackAdd user/repo1 user/repo2)",
})

-- Remover plugins do pack.lua
vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs)
end, {
  nargs = "+",
  desc = "Delete plugins (:PackDel plugin1 plugin2)",
})

-- Atualizar todos os plugins ou específicos
vim.api.nvim_create_user_command("PackUpdate", function(opts)
  if opts.args:match("%S") then
    local plugins = vim.split(opts.args, "%s+", { trimempty = true })
    vim.pack.update(plugins)
  else
    vim.pack.update()
  end
end, {
  nargs = "*",
  desc = "Update all plugins or specific ones (:PackUpdate [plugin1 plugin2])",
})

-- Listar plugins não-ativos e opcionalmente deletá-los
vim.api.nvim_create_user_command("PackCheck", function()
  local non_active = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  if #non_active == 0 then
    vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
    return
  end

  vim.print("😴 Non-active plugins :")
  print(" ")
  for _, name in ipairs(non_active) do
    print(name)
  end

  print(" ")

  local choice = vim.fn.confirm(
    "Delete ALL non-active plugins from disk?",
    "&Yes\n&No",
    2 -- padrão = No
  )

  if choice == 1 then
    vim.pack.del(non_active)
    vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
    print("Non-active plugins deleted!")
    vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
  else
    vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
  end
end, { desc = "List non-active plugins and select to delete" })

-- Salvar macro em arquivo
vim.api.nvim_create_user_command("SaveMacro", function(params)
  local name = params.args
  local dir = vim.fn.expand("~/.config/nvim/macros/")
  local file = dir .. name .. ".macro"
  local content = vim.fn.getreg("q")

  vim.fn.mkdir(dir, "p")
  vim.fn.writefile({ content }, file, "a")
end, { nargs = 1, desc = "Save macro from register q to file" })

-- Carregar macro de arquivo
vim.api.nvim_create_user_command("LoadMacro", function(params)
  local name = params.args
  local dir = vim.fn.expand("~/.config/nvim/macros/")
  local file = dir .. name .. ".macro"

  local content = vim.fn.readfile(file)
  vim.fn.setreg("q", content)
end, { nargs = 1, desc = "Load macro from file to register q" })

-- Recarregar configuração
vim.api.nvim_create_user_command("Reload", function()
  vim.cmd(":source $MYVIMRC")
end, { desc = "Reload Neovim configuration" })
