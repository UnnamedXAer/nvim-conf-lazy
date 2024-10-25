-- give those priority in the suggested word list
vim.opt.sps = "file:~/.config/nvim/spell/sugg,best" -- TODO: does this even do anything??
vim.opt.spelllang = "en_us"
vim.opt.spell = true

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

    ---- spelling in every buffer
    -- vim.opt_local.spell = true
  end,
})

-- local function augroup(name)
--   return vim.api.nvim_create_augroup("my_group-" .. name, { clear = true })
-- end
-- -- wrap for spell in text filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("wrap_spell"),
--   pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
--   callback = function()
--     -- vim.opt_local.wrap = true
--     -- vim.opt_local.spell = true
--   end,
-- })
