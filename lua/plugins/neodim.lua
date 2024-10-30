return {
  "zbirenbaum/neodim",
  event = "LspAttach",
  config = function()
    -- print("neodimming...")
    local un_used_here1 = 5

    require("neodim").setup({
      alpha = 0.75,
      blend_color = "#000000",
      hide = {
        underline = true,
        virtual_text = true,
        signs = true,
      },
      regex = {
        ["*"] = {
          "[uU]nused",
          "[nN]ever [rR]ead",
          "[nN]ot [rR]ead",
        },
        -- ["python"] = {
        --   "W0611",
        --   "W0613",
        -- },
      },
      priority = 128,
      -- priority = 228,
      disable = {},
    })
  end,
}
