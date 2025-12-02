-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tab and Shift Spacing
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Use Undo Tree for undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.cmdheight = 0
vim.opt.updatetime = 50

-- Clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
