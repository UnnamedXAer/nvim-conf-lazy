-- General purpose linters

-- https://github.com/mfussenegger/nvim-lint

return {
  "mfussenegger/nvim-lint",
  -- event = "BufWritePost",
  -- event = "BufReadPost",
  event = { "BufReadPre", "BufNewFile" },
  -- event = {  },
  config = function()
    --Define a table of linters for each filetype (not extensions).
    -- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters

    -- print("nvim-lint -> config")

    local lint = require("lint")

    lint.linters_by_ft = {
      markdows = {
        "vale",
      },
      python = {
        -- 'flake8',
        -- 'mypy',
        "pylint",
      },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
    }
    --
    -- lint.linters.eslint_d.args = {
    --   "--no-warn-ignored", -- <-- this is the key argument
    --   "--format",
    --   "json",
    --   "--stdin",
    --   "--stdin-filename",
    --   function()
    --     return vim.api.nvim_buf_get_name(0)
    --   end,
    -- }

    local lint_autogroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Automatically run linters after saving. Use "InsertLeave" for more aggressive linting.

    -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    vim.api.nvim_create_autocmd({
      -- "BufReadPost",
      "BufEnter",
      "InsertLeave",
      "TextChanged",
      "BufWritePost",
    }, {

      group = lint_autogroup,

      -- Only run linter for the following extensions. Remove this to always run.
      -- pattern = { "*.py" },

      callback = function()
        -- TODO: maybe we could check if linter supports stdin and only try linting when the write event triggered this event or define multipre aucomand for different files defining "pattern"

        -- print("try lint...")
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require("lint").try_lint()
        -- lint.try_lint(nil, { ignore_errors = false })

        -- You can call `try_lint` with a linter name or a list of names to always
        -- run specific linters, independent of the `linters_by_ft` configuration
        -- require("lint").try_lint("cspell")
        require("lint").try_lint("codespell", { ignore_errors = false })
        -- print("codespell done")
      end,
    })

    print("setting keymap for linter")
    vim.keymap.set("n", "<leader>l", function()
      print("about to lint...")
      lint.try_lint()
      print("lint end")
    end, { desc = "Linter | trigger linting for the current file" })
  end,
}
