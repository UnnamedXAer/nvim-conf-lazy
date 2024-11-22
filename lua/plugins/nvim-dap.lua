-- example config can be found here: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
return {
  "mfussenegger/nvim-dap",
  config = function()
    -- Debugging TODO: it was copy paste, verify if there is not duplicates etc.
    vim.keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
    vim.keymap.set(
      "n",
      "<leader>bB",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
      { desc = "dap | set conditional breakpoint" }
    )
    vim.keymap.set(
      "n",
      "<leader>bc",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>"
    )
    vim.keymap.set(
      "n",
      "<leader>bl",
      "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>"
    )
    vim.keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>")
    vim.keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>")

    vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
    vim.keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
    vim.keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
    vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
    vim.keymap.set("n", "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", { desc = "[d]ap | run to [C]ursor" })

    vim.keymap.set("n", "<leader>dd", function()
      require("dap").disconnect()
      require("dapui").close()
    end)
    vim.keymap.set("n", "<leader>dt", function()
      require("dap").terminate()
      require("dapui").close()
    end)
    vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
    vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
    vim.keymap.set("n", "<leader>di", function()
      require("dap.ui.widgets").hover()
    end, { desc = "dap | hover with current value" })
    vim.keymap.set("n", "<leader>d?", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end, { desc = "dap | show dialog with variables" })
    vim.keymap.set("n", "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", { desc = "dap | pause" })
    vim.keymap.set(
      "n",
      "<leader>df",
      "<cmd>Telescope dap frames<cr>",
      { desc = "dap | dialog with frames aka call stack" }
    )
    vim.keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>", { desc = "dap | show dap commands" })
    vim.keymap.set("n", "<leader>de", function()
      require("telescope.builtin").diagnostics({ default_text = ":E:" })
    end, { desc = "show diagnostics in telescopte" })

    vim.keymap.set(
      "n",
      "<leader>dm",
      function()
        ---@diagnostic disable-next-line: missing-fields
        require("dapui").eval(nil, { enter = true })
      end,
      -- '<Cmd>lua require("dapui").eval()<CR>',
      { desc = "dapui - eval expression under the curson" }
    )
  end,
}
