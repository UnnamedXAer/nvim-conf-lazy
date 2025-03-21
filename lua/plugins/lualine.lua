return {
  -- status line
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom = require("lualine.themes.gruvbox-material")

    -- print("custom: " .. string(custom))
    -- require("common").printTable(custom)
    -- local custom = require("lualine.themes.everforest")

    -- options, see: https://github.com/nvim-lualine/lualine.nvim/wiki/Writing-a-theme#theme-example

    if custom == nil then
      print("cannot configure lualine colors. custom is nil")
      return
    end

    if custom.normal == nil then
      print("cannot configure lualine colors. custom.normal is nil")
      return
    end

    if custom.normal.c == nil then
      print("cannot configure lualine colors. custom.normal.c is nil")
      return
    end

    if custom.normal.c == nil then
      print("cannot configure lualine colors. custom.normal.c is nil")
      return
    end

    for k, v in pairs(custom) do
      if custom[k].c == nil then
        print("cannot configure lualine colors. custom." .. k .. ".c is nil")
        return
      end
    end

    custom.normal.c.bg = "#021426"
    custom.insert.c.bg = "#021426"
    custom.visual.c.bg = "#021426"
    custom.replace.c.bg = "#021426"
    custom.command.c.bg = "#021426"

    custom.inactive.c.bg = "#112233"
    require("lualine").setup({
      options = { theme = custom },
    })

    -- require("lualine").setup({})
  end,
}
