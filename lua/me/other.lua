-- close popups like hover with q when focussed (2x gh)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
    -- disable auto-insertion of comment when entering into new line from commented line
		-- c: Auto-wrap comments when they exceed the textwidth.
		-- vim.opt_local.formatoptions:remove("c")
		-- r: Continue comments after pressing Enter in Insert mode.
		vim.opt_local.formatoptions:remove("r")
		-- o: Continue comments after using the o or O command in Normal mode.
		vim.opt_local.formatoptions:remove("o")
	end,
})
