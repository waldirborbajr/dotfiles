return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"saghen/blink.cmp",
	},
	opts = {
		inlay_hints = { enabled = true },
	},
	config = function()
		require("neodev").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup()
		-- ===========================
		-- Diagnostics globales
		-- ===========================
		vim.diagnostic.config({
			virtual_text = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "ErrorMsg",
					[vim.diagnostic.severity.WARN] = "WarningMsg",
				},
			},
		})

		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		vim.lsp.enable({
			"lua_ls",
			"pyright",
			"gopls",
			"rust_analyzer",
			"clangd",
			"ts_ls",
			"html",
			"cssls",
			"cmake",
			"bashls",
			"docker_compose_language_service",
			"docker_language_server",
			"yamlls",
			"gh_actions_ls",
			"jsonls",
		})
	end,
}
