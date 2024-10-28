-- https://github.com/folke/trouble.nvim

-- TODO: needs keymap setup, see documentation to setup proper keymaps

-- vim.keymap.set(
--   "n",
--   "<leader>tt",
--   "<cmd>Trouble<cr>",
--   -- function ()
--   --
--   --   print("Trouble triggered")
--   -- end,
--   { desc = "Trouble | Open Trouble mode selection" }
-- )

return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>TT",
      "<cmd>Trouble<cr>",
      desc = "Trouble | Open Trouble mode selection",
    },

    {
      "<leader>tt",
      "<cmd>Trouble diagnostics toggle <cr>",
      desc = "Trouble | Open trouble diagnostics.",
    },

    {
      "<leader>tT",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble | Open trouble diagnostics for the current buffer.",
    },
  },
}
