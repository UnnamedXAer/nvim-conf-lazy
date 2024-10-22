-- source: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("custom-fn-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--
-- [[ Install `lazy.vnim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
-- To ckeck the current status of you plugins run:
--    :Lazy
--
-- You can press `?` in this menu for help. Use `:q` to close the window
--
-- To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install plugins.
require("lazy").setup({
	-- Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	-- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
	--
	--    require('gitsigns').setup({ ... })
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Plugins can specify dependencies.
	--
	-- The dependencies are proper plugin specifications as well - anything
	-- you do for a plugin at the top level, you can do for a dependency.
	--
	-- Use the `dependencies` key to specify the dependencies of a particular plugin

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
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
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search by Grep" })
			vim.keymap.set(
				"n",
				"<leader>fg",
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
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis

		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		-- event = "VeryLazy",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
			{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
			{ -- optional completion source for require statements and module annotations
				"hrsh7th/nvim-cmp",
				opts = function(_, opts)
					opts.sources = opts.sources or {}
					table.insert(opts.sources, {
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					})
				end,
			},

			-- Allows extra capabilities provided by nvim-cmp
			-- "hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom-fn-lsp-attach", { clear = true }),
				callback = function(event)
					-- Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					-- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("custom-fn-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("custom-fn-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "custom-fn-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				gopls = {},
				pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				ts_ls = {},
				--

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"black",
				"debugpy",
				"flake8",
				"isort",
				"mypy",
				"pylint",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			--Define a table of linters for each filetype (not extentions).
			-- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters

			require("lint").linters_by_ft = {
				python = {
					-- 'flake8',
					-- 'mypy',
					"pylint",
				},
			}

			-- Automatically run linters after saving. Use "InsertLeave" for more aggressive linting.

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				-- Only run liter for the following extensions. Remove this to always run.
				pattern = { "*.py" },
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	{ -- Autoformat
		-- TODO: I need to have ability to format selection - not whole buffer;
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				-- here is something to read about disabling:
				-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save

				-- this would be the simplest way to disable formatter on save, the `disable_filetypes` triggers warning
				-- local disable_on_save_filetypes = {
				-- 	js = true,
				-- 	javascript= true,
				-- 	sql = true,
				-- 	jsp = true,
				-- }
				-- if disable_on_save_filetypes[vim.bo[bufnr].filetype] then
				-- print("formt_on_save: skipping...")
				-- 	return
				-- end

				--  print("formt_on_save: "..(vim.bo[bufnr].filetype))

				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = {
					-- c = true,
					-- cpp = true,
					js = true,
					javascript = true,
					sql = true,
					jsp = true,
				}

				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "black", "isort" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				javascript = { "prettierd", "prettier", stop_after_first = true },
				-- ["*"] = { "codespell" },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					-- ["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-k>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					-- ["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- ['<Tab>'] = cmp.mapping.select_next_item(),
					--['<S-Tab>'] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					-- { name = "buffer" }, -- text within current buffer
				},
			})
		end,
	},

	-- { -- You can easily change to a different colorscheme.
	-- 	-- Change the name of the colorscheme plugin below, and then
	-- 	-- change the command in the config to whatever the name of that colorscheme is.
	-- 	--
	-- 	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000, -- Make sure to load this before all the other start plugins.
	-- 	init = function()
	-- 		-- Load the colorscheme here.
	-- 		-- Like many other themes, this one has different styles, and you could load
	-- 		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
	-- 		-- vim.cmd.colorscheme("tokyonight-night")
	--
	-- 		-- You can configure highlights by doing something like:
	-- 		vim.cmd.hi("Comment gui=none")
	-- 	end,
	-- },
	-- { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("everforest").setup({
				background = "hard",
			})

			vim.cmd.colorscheme("everforest")
		end,
	},

	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup(
				-- comments with
				{
					mappings = {
						comment = "gc",
						comment_line = "gcc",
						comment_visual = "gc",
						textobject = "gc",
					},
				}
			)

			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- -- Simple and easy statusline.
			-- --  You could remove this setup call if you don't like it,
			-- --  and try some other statusline plugin
			-- local statusline = require("mini.statusline")
			-- -- set use_icons to true if you have a Nerd Font
			-- statusline.setup({ use_icons = vim.g.have_nerd_font })
			--
			-- -- You can configure sections in the statusline by overriding their
			-- -- default behavior. For example, here we set the section for
			-- -- cursor location to LINE:COLUMN
			-- ---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			-- 	return "%2l:%-2v"
			-- end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},

	-- The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },

	{
		"fei6409/log-highlight.nvim",
		config = function()
			require("log-highlight").setup({})
		end,
	},
	{
		"zbirenbaum/neodim",
		event = "LspAttach",
		config = function()
			require("neodim").setup({
				alpha = 0.75,
				blend_color = "#000000",
				hide = {
					underline = true,
					virtual_text = true,
					signs = true,
				},
				regex = {
					"[uU]nused",
					"[nN]ever [rR]ead",
					"[nN]ot [rR]ead",
				},
				priority = 128,
				disable = {},
			})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},

	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			-- log_level = 'debug',
		},
	},

	-- session (aka opened buffers auto save and restore)
	-- {
	-- 	"nyngwang/suave.lua",
	-- 	config = function()
	-- 		require("suave").setup({
	-- 			-- menu_height = 6,
	-- 			auto_save = {
	-- 				enabled = true,
	-- 				-- exclude_filetypes = {},
	-- 			},
	-- 			store_hooks = {
	-- 				-- DON'T call `vim.cmd('wa')` here. Use `setup.auto_save` instead. (See #4)
	-- 				before_mksession = {
	--
	-- 					-- function ()
	-- 					--   -- `rcarriga/nvim-dap-ui`.
	-- 					--   require('dapui').close()
	-- 					-- end,
	-- 					-- function ()
	-- 					--   -- `nvim-neo-tree/neo-tree.nvim`.
	-- 					--   for _, w in ipairs(vim.api.nvim_list_wins()) do
	-- 					--     if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w), 'ft') == 'neo-tree' then
	-- 					--       vim.api.nvim_win_close(w, false)
	-- 					--     end
	-- 					--   end
	-- 					-- end,
	-- 				},
	-- 				after_mksession = {
	-- 					-- the `data` param is Lua table, which will be stored in json format under `.suave/` folder.
	-- 					function(data)
	-- 						print("after session")
	-- 						-- store current colorscheme.
	-- 						data.colorscheme = vim.g.colors_name
	-- 					end,
	-- 				},
	-- 			},
	-- 			restore_hooks = {
	-- 				after_source = {
	-- 					function(data)
	-- 						print("after source hook")
	-- 						if not data then
	-- 							return
	-- 						end
	-- 						-- restore colorscheme.
	-- 						vim.cmd(string.format(
	-- 							[[
	--              color %s
	--              doau ColorScheme %s
	--            ]],
	-- 							data.colorscheme,
	-- 							data.colorscheme
	-- 						))
	-- 					end,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		-- config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
		config = function()
			require("undotree").setup({
				window = {
					winblend = 5,
				},
			})
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local custom_gruvbox = require("lualine.themes.everforest")
			custom_gruvbox.normal.c.bg = "#112233"
			require("lualine").setup({
				options = { theme = custom_gruvbox },
			})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			-- Debugging TODO: it was copy paste, verify if there is not duplicates ect.
			vim.keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
			vim.keymap.set(
				"n",
				"<leader>bc",
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>"
			)
			vim.keymap.set(
				"n",
				"<leader>bl",
				"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>"
			)
			vim.keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>")
			vim.keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>")
			vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
			vim.keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
			vim.keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
			vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
			vim.keymap.set("n", "<leader>dd", function()
				require("dap").disconnect()
				require("dapui").close()
			end)
			vim.keymap.set("n", "<leader>dt", function()
				require("dap").terminate()
				require("dapui").close()
			end)
			vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
			vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
			vim.keymap.set("n", "<leader>di", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set("n", "<leader>d?", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)
			vim.keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>")
			vim.keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>")
			vim.keymap.set("n", "<leader>de", function()
				require("telescope.builtin").diagnostics({ default_text = ":E:" })
			end)
		end,
	},

	-- python degugging
	-- source: https://github.com/bcampolo/nvim-starter-kit/blob/python/.config/nvim/lua/plugins/nvim-dap-ui.lua
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			-- require("dap-python").setup("/usr/bin/python")
			require("dap-python").setup("/usr/bin/python3.10")
			-- require("dap-python").setup("python")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},

		config = function(_, opts)
			local dap = require("dap")
			require("dapui").setup(opts)

			dap.listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				-- Commented to prevent DAP UI from closing when unit tests finish
				-- require("dapui").close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				-- Commented to prevent DAP UI from closing when unit tests finish
				-- require("dapui").close()
			end

			-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

			-- vim.keymap.set(
			-- 	"n",
			-- 	"<leader>dm",
			-- 	'<Cmd>lua require("dapui").eval()<CR>',
			-- 	{ desc = "dapui - eval expression under the curson" }
			-- )
		end,
	},
})

-- vim.cmd([[colorscheme everforest]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
