-- status line
return
-- status line
{
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_gruvbox = require("lualine.themes.everforest")
		custom_gruvbox.normal.c.bg = "#112233"
		require("lualine").setup({
			options = { theme = custom_gruvbox },
		})
	end,
}
