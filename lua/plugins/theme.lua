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
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("everforest").setup({
        background = "medium",
      })

      vim.cmd.colorscheme("everforest")
    end,
  },
}