return {
  "yorickpeterse/nvim-window",
  keys = {
    { "<Tab>", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
  },
  config = function()
    require("nvim-window").setup({ normal_hl = "Error", hint_hl = "Bold" })
  end,
}
