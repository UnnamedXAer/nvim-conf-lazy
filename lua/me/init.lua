--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--vim.opt.guicursor = "" -- fat cursor in insert mode

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.linebreak = true -- wrap long lines at 'breaktat' (if 'wrap' is set)

vim.opt.splitbelow = true -- horizontal split always below
vim.opt.splitright = true -- vertical split always to right

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
if jit and jit.os == "Windows" then
  vim.undodir = os.getenv("TMP") .. "/.vim/undodir" -- long memory for undodir
end
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true -- show search results while typing

vim.opt.inccommand = "split" -- show command (eg replace :s/...) results on fly

vim.opt.ignorecase = true -- search ignore casing entirely
--vim.opt.smartcase = true -- search when at least one upper case then search is case sensitive

vim.opt.termguicolors = true -- enable gui colors
vim.opt.showmatch = true -- Highlight matching parenthesis

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "90"
-- vim.opt.colorcolumn = "+1" -- draw colored column one step to the right of desired max width

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Disable nvim intro
vim.opt.shortmess:append("sI")

-- give those priority in the suggested word list
-- vim.opt.sps = "file:~/.config/nvim/spell/sugg,best" -- TODO: does this even do anything??
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("me.keymap")
require("me.other")
require("me.lazy")
