return {
  "williamboman/mason.nvim",
  dependiences = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- print("config of mason ")

    -- require("custom.lsp_format_lint")
    ---------------------------------------------------
    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Enable the following language servers
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- clangd = {},
      gopls = {},
      pyright = {},
      -- ruff_lsp = {},
      ts_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local ensure_installed = vim.tbl_keys(servers or {})
    -- print("servers:   ---------------------------")
    -- require("common").printTable(ensure_installed)

    vim.list_extend(ensure_installed, {
      "stylua",
      "gopls",
      "delve", -- go debugger
      "black",
      "debugpy",
      "isort",
      "prettier",
      "eslint_d",
      "pylint",
      -- "ruff",
      -- "cpesll",
      "codespell",
    })

    local os_name = require("common").get_os_full_name()
    local is_rpi = string.find(os_name, "unnamedpi") ~= nil
    if is_rpi then
      ensure_installed = {}
    end

    -- print("all to install:   ---------------------------")
    -- require("common").printTable(ensure_installed)

    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsStartingInstall",
      callback = function()
        -- vim.schedule(function()
        -- print("➡️l mason-tool-installer is starting")
        -- print(vim.inspect(e.data))
        -- end)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      callback = function(e)
        -- local data_str = vim.inspect(e.data)
        -- if data_str == "{}" then
        --   return
        -- end

        -- vim.schedule(function()
        --   print("🆗 all installed:")
        --   print(data_str) -- print the table that lists the programs that were installed
        -- end)
      end,
    })

    require("mason-tool-installer").setup({
      -- debounce_hours = 0,
      ensure_installed = ensure_installed,
      -- run_on_start= true,
      -- auto_update = true,
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    ---------------------------------------------------
  end,
}
