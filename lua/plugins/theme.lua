return {
  -- {
  --   "ribru17/bamboo.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("bamboo").setup({
  --       -- Main options --
  --       -- to use the light theme, set `vim.o.background = 'light'`
  --       style = "vulgaris", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
  --       toggle_style_key = nil, -- Keybind to toggle theme style. Leave it nil to disable it, or set it to a string, e.g. "<leader>ts"
  --       toggle_style_list = { "vulgaris", "multiplex", "light" }, -- List of styles to toggle between
  --       transparent = false, -- Show/hide background
  --       dim_inactive = false, -- Dim inactive windows/buffers
  --       term_colors = true, -- Change terminal color as per the selected theme style
  --       ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
  --       cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  --
  --       -- Change code style ---
  --       -- Options are anything that can be passed to the `vim.api.nvim_set_hl` table
  --       -- You can also configure styles with a string, e.g. keywords = 'italic,bold'
  --       code_style = {
  --         comments = { italic = false },
  --         conditionals = { italic = false },
  --         keywords = {},
  --         functions = {},
  --         namespaces = { italic = false },
  --         parameters = { italic = false },
  --         strings = {},
  --         variables = {},
  --       },
  --
  --       -- Lualine options --
  --       lualine = {
  --         transparent = false, -- lualine center bar transparency
  --       },
  --
  --       -- Custom Highlights --
  --       colors = {}, -- Override default colors
  --       highlights = {}, -- Override highlight groups
  --
  --       -- Plugins Config --
  --       diagnostics = {
  --         darker = true, -- darker colors for diagnostic
  --         undercurl = true, -- use undercurl instead of underline for diagnostics
  --         background = true, -- use background color for virtual text
  --       },
  --     })
  --
  --     require("bamboo").load() -- enable theme
  --   end,
  -- },

  -- EVERFOREST

  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- Optional; default configuration will be used if setup isn't called.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require("everforest").setup({
  --       background = "medium",
  --     })
  --
  --     vim.cmd.colorscheme("everforest")
  --   end,
  -- },

  -- quite ok.
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.

      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = "hard" -- soft, medium, hard
      vim.g.gruvbox_material_foreground = "original" --  material, mix, original
      -- vim.g.gruvbox_material_menu_selection_background = "purple"
      -- vim.g.gruvbox_material_cursor = "purple"

      -- vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material")

      -- https://neovim.io/doc/user/builtin.html#sign_define()
      vim.fn.sign_define("DapBreakpoint", {
        text = "", -- nerdfonts icon here
        texthl = "yellow", -- color of the icon | color or some kind of group
        linehl = "", -- color of the line text (your code)
        numhl = "blue", -- color of the line number
        culhl = "", -- color of the icon defined above when the cursor in on that line
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "yellow", -- color of the icon | color or some kind of group
        linehl = "", -- color of the line text (your code)
        numhl = "blue", -- color of the line number
        culhl = "", -- color of the icon defined above when the cursor in on that line
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "red",
        linehl = "",
        numhl = "orange",
      })

      -- vim.fn.sign_define("DapBreakpoint", {
      --   text = "", -- nerdfonts icon here
      --   texthl = "DapBreakpointSymbol",
      --   linehl = "DapBreakpoint",
      --   numhl = "DapBreakpoint",
      -- })

      -- vim.fn.sign_define("DapStopped", {
      --   text = "",
      --   texthl = "DapStoppedSymbol",
      --   linehl = "DapBreakpoint",
      --   numhl = "DapBreakpoint",
      -- })
    end,
  },

  -- CATPPUCCIN

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
}
