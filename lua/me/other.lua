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

local function printAvailableColorschemes()
  local t = (vim.fn.getcompletion("", "color"))

  require("common").printTable(t)

  local a = vim.ui.input({ prompt = "Pick number: " }, function(input)
    print("\n the input is" .. input)
    local number = tonumber(input)
    if number == nil then
      vim.cmd.colorscheme(input)
      print("\ntemporaryly colorscheme set to: " .. input)
    else
      print("\n the number is" .. number)
      local name = t[number]
      vim.cmd.colorscheme(name)
      print("\ntemporaryly colorscheme set to: " .. name)
    end
  end)
end

vim.api.nvim_create_user_command("Colorschemes", printAvailableColorschemes, {})

--
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "exit the TERMINAL mode" })

vim.keymap.set("n", ",st", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end, { desc = "open terminal at the botto of the screen" })
