return {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    -- WARN: don't forget to install delve
    -- go install github.com/go-delve/delve/cmd/dlv@latest
    -- in wsl your may need to define following in `~/.profile`
    -- export PATH="$PATH:$HOME/go/bin"
    -- also in wsl your dlv command or similar may try to use windows' installation.
    -- use `which dlv` to determine what path it uses

    require("dap-go").setup()

    local save_before_action = require("common").save_before_action
    --
    vim.keymap.set("n", "<leader>du", save_before_action(require("dap-go").debug_test))
    vim.keymap.set("n", "<leader>dU", save_before_action(require("dap-go").debug_last_test))

    local dap = require("dap")

    local configurations_go = {
      -- {
      --   -- Must be "go" or it will be ignored by the plugin
      --   type = "go",
      --   name = "Attach remote",
      --   mode = "remote",
      --   request = "attach",
      -- },
    }

    for _, config in ipairs(configurations_go) do
      table.insert(dap.configurations.go, config)
    end
  end,
}
