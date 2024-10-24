return { -- Autoformat
	-- TODO: I need to have ability to format selection - not whole buffer;
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = true,
		format_on_save = function(bufnr)
			-- here is something to read about disabling:
			-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save

			-- this would be the simplest way to disable formatter on save, the `disable_filetypes` triggers warning
			-- local disable_on_save_filetypes = {
			-- 	js = true,
			-- 	javascript= true,
			-- 	sql = true,
			-- 	jsp = true,
			-- }
			-- if disable_on_save_filetypes[vim.bo[bufnr].filetype] then
			-- print("formt_on_save: skipping...")
			-- 	return
			-- end

			--  print("formt_on_save: "..(vim.bo[bufnr].filetype))

			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = {
				-- c = true,
				-- cpp = true,
				js = true,
				javascript = true,
				sql = true,
				jsp = true,
			}

			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 500,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			python = { "black", "isort" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			javascript = { "prettierd", "prettier", stop_after_first = true },
			-- ["*"] = { "codespell" },
		},
	},
}
