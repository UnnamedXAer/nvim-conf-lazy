return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  --	event = "VimEnter",
  -- lazy = true,
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    { "nvim-telescope/telescope-live-grep-args.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local telescope = require("telescope")
    local telescopeConfig = require("telescope.config")

    local vimGrepArguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files
    table.insert(vimGrepArguments, "--hidden")
    -- I don't want to search in .git directory
    table.insert(vimGrepArguments, "--glob")
    table.insert(vimGrepArguments, "!**/.git/*")

    local telescopeActions = require("telescope.actions")

    telescope.setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        file_ignore_patterns = {
          ".git",
          -- "**/.git/*",
        },
        -- hidden = true - is not supported in text grep commands
        vimgrep_arguments = vimGrepArguments,
        mappings = {
          -- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          i = {
            ["<C-k>"] = telescopeActions.move_selection_previous,
            ["<C-j>"] = telescopeActions.move_selection_next,
            ["<C-d>"] = telescopeActions.delete_buffer,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")

    -- enter go to file in the current buffer
    -- <C-x> go to file selection as a split
    -- <C-v> go to file selection as a vsplit
    -- <C-t> go to a file in a new tab

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search current Word" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search by Grep" })
    vim.keymap.set(
      "n",
      "<leader>fG",
      '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>',
      { desc = 'Search by Grep with optional args use `fun` or `"fun" -t md` to search only markdown files.' }
    )
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search Diagnostics" })

    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Search Recent Open Files" })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Search Resume" })

    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })

    -- vim.keymap.set("n", "<leader>fi", "<cmd>AdvancedGitSearch<CR>", { desc = "Search git" })

    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search Help" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Search Keymaps" })

    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>f/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "Search / in Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>fc", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search Neovim files" })
  end,
}
