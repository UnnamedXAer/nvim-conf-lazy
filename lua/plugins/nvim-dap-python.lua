return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local pythonPath = "python3"
    local dap = require("dap")
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "My: Launch file",
        program = "${file}",
        pythonPath = function()
          -- return "/usr/bin/python"
          return pythonPath
        end,
      },
    }

    -- require("dap-python").setup("/usr/bin/python")
    -- require("dap-python").setup("python3")
    -- require("dap-python").setup("/usr/bin/python3.10")
    -- require("dap-python").setup("/usr/bin/python3.13")
    -- require("dap-python").setup("/usr/bin/python3.12")
    require("dap-python").setup(pythonPath)
  end,
}
