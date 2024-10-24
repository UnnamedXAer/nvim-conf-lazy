return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("everforest").setup({
			background = "hard",
		})

		vim.cmd.colorscheme("everforest")
	end,
}
