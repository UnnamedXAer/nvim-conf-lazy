return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local pythonPath = "python3"
    -- local pythonPath = "venv/bin/python3"

    require("dap-python").setup(pythonPath)

    local save_before_action = require("common").save_before_action

    vim.keymap.set("n", "<leader>ds", save_before_action(require("dap-python").debug_selection))
    vim.keymap.set("n", "<leader>du", save_before_action(require("dap-python").test_method))
    vim.keymap.set("n", "<leader>dU", save_before_action(require("dap-python").test_class))

    local dap = require("dap")

    -- to debug with 'venv' activated you need to install debugpy for that venv.
    -- pythonPath + ` -m debugpy --version` must work in the shell
    -- e.q. `python3 -m debugpy --version`

    -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    local configurations_python = {
      {
        type = "python",
        request = "launch",
        name = "venv: Launch file",
        program = "${file}",
        pythonPath = function()
          -- return "/usr/bin/python"
          return "venv/bin/python3"
        end,
      },

      {
        type = "python",
        request = "launch",
        name = "venv: Launch main.py",
        program = "./main.py",
        pythonPath = function()
          -- return "/usr/bin/python"
          return "venv/bin/python3"
        end,
      },

      {
        type = "python",
        request = "launch",
        name = "Launch file with default python",
        program = "{file}",
        pythonPath = function()
          -- return "/usr/bin/python"
          return "python"
        end,
      },
    }

    for _, config in ipairs(configurations_python) do
      table.insert(dap.configurations.python, config)
    end

    -- dap.configurations.python = configurations_python

    -- print("dap python configs:")
    -- for k, v in dap.configurations.python do
    --   print("k: " .. k .. ";\tv: " .. tostring(v))
    -- end

    -- require("dap-python").setup("/usr/bin/python")
    -- require("dap-python").setup("python3")
    -- require("dap-python").setup("/usr/bin/python3.10")
    -- require("dap-python").setup("/usr/bin/python3.13")
    -- require("dap-python").setup("/usr/bin/python3.12")
  end,
}
