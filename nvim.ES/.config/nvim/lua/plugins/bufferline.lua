return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"famiu/bufdelete.nvim",
	},
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				style_preset = {
					bufferline.style_preset.no_italic,
				},
				move_with_mouse = true,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						padding = 1,
					},
				},
				close_command = function(bufnr)
					require("bufdelete").bufdelete(bufnr, true)
				end,
				right_mouse_command = "Bdelete! %d",
				diagnostics = false, -- Sin diagnósticos para un diseño limpio
				mode = "buffers",
				show_buffer_close_icons = true,
				show_close_icon = false,
				separator_style = "thin", -- Separadores simples
				always_show_bufferline = true,
				indicator = {
					icon = "▎", -- Indicador del buffer activo
					style = "icon",
				},
				modified_icon = "●", -- Icono para buffers modificados
				left_trunc_marker = "<", -- Indicador de truncamiento izquierdo
				right_trunc_marker = ">", -- Indicador de truncamiento derecho
			},
			highlights = {
				-- Eliminar el fondo y solo mostrar la línea verde debajo del buffer seleccionado
				buffer_selected = {
					bold = true, -- No usar negrita
				},
				modified_selected = {
					fg = "#66f9bb", -- Color de íconos modificados (verde claro)
					bg = "NONE", -- Sin fondo
				},
				-- Solo agregamos la línea verde debajo del buffer seleccionado
				indicator_selected = {
					fg = "#66f9bb", -- Línea verde debajo del buffer seleccionado
				},
			},
		})
	end,
}

