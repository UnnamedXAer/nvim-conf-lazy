-- python degugging
-- source: https://github.com/bcampolo/nvim-starter-kit/blob/python/.config/nvim/lua/plugins/nvim-dap-ui.lua
return
-- python degugging
-- source: https://github.com/bcampolo/nvim-starter-kit/blob/python/.config/nvim/lua/plugins/nvim-dap-ui.lua
{
	"mfussenegger/nvim-dap-python",
	ft = "python",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function()
		-- require("dap-python").setup("/usr/bin/python")
		require("dap-python").setup("/usr/bin/python3.10")
		-- require("dap-python").setup("python")
	end,
}
