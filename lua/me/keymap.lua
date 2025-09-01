-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`

-- unset F1
vim.keymap.set({
  "n", -- Normal mode
  "i", -- Insert mode
  "v", -- Visual mode
  "x", -- Visual Block mode
  "o", -- Operator-pending mode
  "s", -- Select mode
  "c", -- Command-line mode
  "t", -- Terminal mode
}, "<F1>", "<nop>", { noremap = false })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("i", "<C-c>", "<Esc>") -- makes Esc exactly the same as Ctrl-c

vim.keymap.set("i", "jk", "<Esc>") -- quick Esc when typing
vim.keymap.set("n", "<C-n>", "<cmd>bn<cr>", { desc = "General | Buffer next" }) -- next buffer
vim.keymap.set("n", "<C-p>", "<cmd>bp<cr>", { desc = "General | Buffer previous" }) -- next buffer

vim.keymap.set(
  { "v", "n" },
  "<leader>Q",
  ":bp|:bd#<CR>",
  { desc = "General | Quit visible buffer on go back to the previous buffer" }
) -- quit visible buffer: (go back to prev buffer and quit the one that was visible)

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

-- resize windows
vim.keymap.set("n", "<M-,>", "<c-w>5<", { desc = "resize window: width" })
vim.keymap.set("n", "<M-.>", "<c-w>5>", { desc = "resize window: width" })
vim.keymap.set("n", "<M-t>", "<c-w>+", { desc = "resize window: height" })
vim.keymap.set("n", "<M-s>", "<c-w>-", { desc = "resize window: height" })

-- better go down (does not skip wrapped part of a line)
vim.keymap.set(
  { "n", "v" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { desc = "General | Better down", expr = true, silent = true }
)
vim.keymap.set(
  { "n", "v" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { desc = "General | Better up", expr = true, silent = true }
)

-- other
-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end)

vim.keymap.set("n", "gh", function()
  vim.lsp.buf.hover()
end, { remap = false, desc = "Trigger hover popup, use twice to focus that popup to be eable e.g. to scroll it." })

vim.keymap.set("n", "<F2>", function()
  vim.lsp.buf.rename()
end, { remap = false })

-- append to all words that match word under curosor
-- vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  "<cmd>lua vim.diagnostic.open_float()<CR>",
  { desc = "displays floating window (similar to hover) with errors, warning, etc." }
)

vim.keymap.set("n", "<leader>nm", "<cmd>messages<CR>", { desc = "Neovim | Messages", silent = true })
