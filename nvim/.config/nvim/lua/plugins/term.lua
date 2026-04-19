return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		-- Determinar el shell a usar dependiendo del sistema operativo
		local shell = ""
		if vim.loop.os_uname().sysname == "Windows_NT" then
			shell = "pwsh" -- Usar pwsh en Windows
		else
			shell = vim.o.shell -- Usar el shell predeterminado en Linux/MacOS
		end

		-- Configuración de ToggleTerm
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "float" then
					return 15 -- Tamaño del terminal flotante
				elseif term.direction == "vertical" then
					return 50 -- Tamaño del terminal vertical
				else
					return 8 -- Tamaño del terminal horizontal
				end
			end,
			direction = "horizontal", -- Dirección predeterminada del terminal
			close_on_exit = true, -- Cerrar el terminal al salir
			shade_terminals = false, -- No sombrear terminales
			float_opts = {
				border = "curved", -- Borde curvado para el terminal flotante
				width = 100, -- Ancho del terminal flotante
				height = 20, -- Altura del terminal flotante
				winblend = 20, -- Nivel de transparencia
			},
			shell = shell, -- Usar el shell configurado
		})
	end,
}
