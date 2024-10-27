-- General purpose linters

-- https://github.com/mfussenegger/nvim-lint

return {
  "mfussenegger/nvim-lint",
  event = "BufWritePost",
  -- event = {  },
  config = function()
    --Define a table of linters for each filetype (not extensions).
    -- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters

    print("nvim-lint -> config")

    require("lint").linters_by_ft = {
      markdows = {
        "vale",
      },
      python = {
        -- 'flake8',
        -- 'mypy',
        "pylint",
      },
    }

    -- Automatically run linters after saving. Use "InsertLeave" for more aggressive linting.

    -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "BufWritePost" }, {
      -- Only run liter for the following extensions. Remove this to always run.
      pattern = { "*.py" },
      callback = function()
        print("try lint...")
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        require("lint").try_lint()

        -- You can call `try_lint` with a linter name or a list of names to always
        -- run specific linters, independent of the `linters_by_ft` configuration
        require("lint").try_lint("cspell")
      end,
    })
  end,
}
