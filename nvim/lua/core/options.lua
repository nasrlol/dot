-- Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cmdheight = 1

vim.opt.linespace = 2

vim.opt.showtabline = 2
vim.opt.laststatus = 3

vim.opt.pumheight = 10

-- Editing Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Wrapping
vim.opt.wrap = false
vim.opt.linebreak = true

-- Navigation & Splits
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.redrawtime = 1500
vim.opt.ttimeoutlen = 10

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- File Handling
vim.opt.autoread = true
vim.opt.hidden = true

-- Misc
vim.opt.tags = { "./tags;", "tags;" }
vim.opt.iskeyword:remove("_")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.shortmess:append("c")
vim.opt.fillchars = { eob = " " }
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
