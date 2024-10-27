return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    -- require("dap-python").setup("/usr/bin/python")
    -- require("dap-python").setup("/usr/bin/python3.10")
    -- require("dap-python").setup("/usr/bin/python3.13")
    -- require("dap-python").setup("/usr/bin/python3.12")
    require("dap-python").setup("python3")
  end,
}
