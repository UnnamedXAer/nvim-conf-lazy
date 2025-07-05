return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    -- https://github.com/nvim-neotest/nvim-nio
    "nvim-neotest/nvim-nio",
    {
      -- https://github.com/theHamsta/nvim-dap-virtual-text
      -- inline variable text while debugging
      "theHamsta/nvim-dap-virtual-text",
      lazy = true,
      opts = {
        -- Display debug text as a comment
        commented = true,
        -- Customize virtual text
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
      },
    },

    -- https://github.com/nvim-telescope/telescope-dap.nvim
    "nvim-telescope/telescope-dap.nvim", -- telescope integration with dap
  },

  opts = {
    -- controls = {
    -- 	element = "repl",
    -- 	enabled = false,
    -- 	icons = {
    -- 		disconnect = "",
    -- 		pause = "",
    -- 		play = "",
    -- 		run_last = "",
    -- 		step_back = "",
    -- 		step_into = "",
    -- 		step_out = "",
    -- 		step_over = "",
    -- 		terminate = "",
    -- 	},
    -- },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    force_buffers = true,
    -- icons = {
    -- 	collapsed = "",
    -- 	current_frame = "",
    -- 	expanded = "",
    -- },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.50,
          },
          {
            id = "watches",
            size = 0.10,
          },
          {
            id = "stacks",
            size = 0.30,
          },
          {
            id = "breakpoints",
            size = 0.10,
          },
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      },
    },
    -- mappings = {
    -- 	edit = "e",
    -- 	expand = { "<CR>", "<2-LeftMouse>" },
    -- 	open = "o",
    -- 	remove = "d",
    -- 	repl = "r",
    -- 	toggle = "t",
    -- },
    render = {
      indent = 1,
      max_value_lines = 100,
    },
  },

  config = function(_, opts)
    local dap = require("dap")

    require("dapui").setup(opts)

    -- local configure_c_debugger = function(dap)
    --   -- would be nice to find better place for this
    --
    --   local mason_registry = require("mason-registry")
    --   local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/" -- TODO: `get_install_path` this does not exist anymore :(
    --   local codelldb_path = codelldb_root .. "adapter/codelldb"
    --   local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
    --   dap.adapters.codelldb = {
    --     type = "server",
    --     port = "${port}",
    --     host = "127.0.0.1",
    --     executable = {
    --       command = codelldb_path,
    --       args = { "--liblldb", liblldb_path, "--port", "${port}" },
    --     },
    --   }
    --
    --   dap.configurations.c = {
    --     {
    --       name = "c_launch",
    --       type = "codelldb",
    --       request = "launch",
    --       -- program = function()
    --       --   -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    --       --   return vim.fn.input("Path to executable> ", vim.fn.getcwd() .. "/", "file")
    --       -- end,
    --
    --       program = function()
    --         -- local path = "${fileDirname}/${fileBasenameNoExtension}"
    --         local path = vim.fn.getcwd() .. "/revers_binary_num"
    --         print("launching: '" .. path .. "'")
    --         return path
    --       end,
    --
    --       -- you need to build the file yourself: gcc ./revers_binary_num.c -O0 -g -o revers_binary_num
    --       -- -g -O0 to include debug symbol
    --
    --       cwd = "${workspaceFolder}",
    --       stopOnEntry = false,
    --     },
    --   }
    -- end
    --
    -- configure_c_debugger(dap)

    -- dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
    -- dap.defaults.fallback.terminal_win_cmd = "new"

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require("dapui").open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require("dapui").close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require("dapui").close()
    end

    dap.listeners.after.event_exited["dapui_config"] = function()
      local buffer_name = vim.api.nvim_buf_get_name(0)
      print(buffer_name) -- This will print the full path of the current buffer
      if buffer_name:find("[dap-terminal]") then
        print("stopping insert")
        vim.cmd("stopinsert")
      end
    end

    -- -- the following is supposed to delete buffer (dap-terminal) when it was "close - hidden"
    -- -- it happen when we use :q on that buffer
    -- vim.api.nvim_create_autocmd("BufHidden", {
    -- 	pattern = "[dap-terminal]*",
    -- 	callback = function(arg)
    -- 		name = "<<none>>"
    -- 		if arg.buf ~= nil then
    -- 			name = arg.buf.name
    -- 		end
    --
    -- 		print("-- deleting buffer" .. name)
    -- 		vim.schedule(function()
    -- 			vim.api.nvim_buf_delete(arg.buf, { force = true })
    -- 		end)
    -- 	end,
    -- })

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

    -- vim.keymap.set(
    -- 	"n",
    -- 	"<leader>dm",
    -- 	'<Cmd>lua require("dapui").eval()<CR>',
    -- 	{ desc = "dapui - eval expression under the curson" }
    -- )
  end,
}
