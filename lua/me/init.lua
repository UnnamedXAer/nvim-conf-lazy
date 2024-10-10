

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--vim.opt.guicursor = "" -- fat cursor in insert mode 

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2 
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.undodir = os.getenv("TMP") .. "/.vim/undodir" -- long memory for undodir
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.ignorecase = true -- search ingore casing etirely
--vim.opt.smartcase = true -- search when at least one upper case then search is case sensitive

vim.opt.termguicolors = true
vim.opt.showmatch = true -- Highlight matching parenthesis

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "90"


-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true


-- Disable nvim intro
vim.opt.shortmess:append "sI"


require("me.keymap")
require("me.lazy")
