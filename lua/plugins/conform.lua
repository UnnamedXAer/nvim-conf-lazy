return {
  -- Formatting

  -- TODO: I need to have ability to format selection - not whole buffer;
  "stevearc/conform.nvim",
  -- event = { "BufWritePre" },
  event = { "BufReadPre", "BufNewFile" },
  -- cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        -- print("manual format triggered")
        require("conform").format({
          async = true,
          lsp_format = "fallback",
          callback = function(error, did_edit)
            print("callback")
            if error ~= nil then
              print("manual format: error: " .. error)
            end
            print("manula format: did_edit: " .. tostring(did_edit))
          end,
        })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  config = function()
    -- print("conform config")

    require("conform").setup({

      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        -- python = {
        -- "ruff_fix", -- To fix lint errors. (ruff with argument --fix)
        -- "ruff_format", -- To run the formatter. (ruff with argument format)
        -- },

        ["*"] = { "codespell" },
      },
      format_on_save = function(bufnr)
        -- print("format on save: start")

        local disable_filetypes = {
          js = true,
          javascript = true,
          jsp = true,
          javaserverpage = true,
          sql = true,
        }

        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          -- lsp_format_opt = "never"
          print("format on save skipped for filetype: " .. vim.bo[bufnr].filetype)
          return
        else
          lsp_format_opt = "fallback"
        end

        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
    })

    -- print("conform config: end")
  end,
}
