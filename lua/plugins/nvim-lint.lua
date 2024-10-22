-- General purpose linters

-- https://github.com/mfussenegger/nvim-lint
return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		--Define a table of linters for each filetype (not extentions).
		-- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters

		print("/plugins: config of lint")

		require("lint").linters_by_ft = {
			python = {
				-- 'flake8',
				-- 'mypy',
				"pylint",
			},
		}

		-- Automatically run linters after saving. Use "InsertLeave" for more aggressive linting.

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			-- Only run liter for the following extensions. Remove this to always run.
			pattern = { "*.py" },
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
