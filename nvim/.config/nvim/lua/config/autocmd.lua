-- Disable auto comment continuation
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Ajustes de formato al abrir cualquier tipo de archivo
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- Evita que los comentarios se inserten automáticamente en nuevas líneas
		vim.opt.formatoptions:remove({ "c", "r", "o" })
		-- Mantiene indentación automática
		vim.opt.autoindent = true
	end,
})

-- Mostrar notificación por cliente LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.server_capabilities.completionProvider then
			print("LSP completions enabled for " .. client.name)
		end
	end,
})

-- borrar buffer no name
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		local bufs = vim.api.nvim_list_bufs()

		if bufname ~= "" then
			for _, buf in ipairs(bufs) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local name = vim.api.nvim_buf_get_name(buf)
					if name == "" and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
						vim.schedule(function()
							require("bufdelete").bufdelete(buf, true)
						end)
					end
				end
			end
		end
	end,
})
