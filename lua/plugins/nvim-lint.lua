return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  -- event = {  },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      markdows = {
        "vale",
      },
      python = {
        -- 'flake8',
        -- 'mypy',
        "pylint",
        -- "ruff",
      },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
    }

    lint.linters.pylint.args = vim.list_extend(lint.linters.pylint.args, {
      "--disable=C0114,C0115,C0116",
      "--disable=too-few-pulic-methods",
    })

    -- lint.linters.pylint.args = {
    --   -- "--max-line-length=20",
    --   -- "--disable=C0114",
    --   -- "--disable=C0111",
    -- }

    -- "--disable", "C0114,C0115,C0116" ,

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
        -- require("lint").try_lint("codespell", { ignore_errors = false }) -- this fucks with "trouble.nvim"
        -- print("codespell done")
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Linter | trigger linting for the current file" })
  end,
}
