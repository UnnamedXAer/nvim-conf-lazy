-- https://github.com/folke/trouble.nvim

-- TODO: needs keymap setup, see documentation to setup proper keymaps
vim.keymap.set(
  "n",
  "<leader>tt",
  "<cmd>Trouble<cr>",
  -- function ()
  --
  --   print("Trouble triggered")
  -- end,
  { desc = "Trouble | Open Trouble mode selection" }
)

return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
}