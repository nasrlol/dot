vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true

vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.tags = { "./tags;", "tags;" }

vim.opt.laststatus = 3   -- single global statusline
vim.opt.showmode = false
vim.opt.cmdheight =

vim.opt.iskeyword:remove("_")
