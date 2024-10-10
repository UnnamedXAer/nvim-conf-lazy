-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("i", "<C-c>", "<Esc>") -- makes Esc exactly the same as Ctrl-c

-- copy/paste
vim.keymap.set({ "n", "v" }, "<leader>v", '"+p')
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>c", 'v"+y')
vim.keymap.set("x", "<leader>p", '"_dP') -- paste text, override selection if any but do not copy selection

-- save
vim.keymap.set({ "n", "v" }, "<leader>w", ":w<CR>")

-- move between windows:
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- other
-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)

-- append to all words that match word under curosor
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
