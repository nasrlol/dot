local opt = vim.opt
local g = vim.g

-- Leader Keys
g.mapleader = " "
g.maplocalleader = " "

-- UI & Appearance
opt.signcolumn     = "no"
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.termguicolors  = true
opt.showmode       = false
opt.cmdheight      = 0
opt.linespace      = 0
opt.showtabline    = 0
opt.laststatus     = 0
opt.pumheight      = 0
opt.list           = false
opt.fillchars      = { eob = " " }
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

-- Formatting
opt.cindent = true
opt.cinoptions = { "l1",    "g0",    "t0",    "(0",    "ws1",   "N-s", "j1",  }
opt.copyindent = true    
opt.preserveindent = true

opt.backspace = "indent,eol,start"

-- Editing Behavior
opt.mouse          = nil 
opt.clipboard      = "unnamedplus"
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.virtualedit    = "all"
opt.iskeyword:remove("_")
opt.formatoptions:remove({ "c", "r", "o" })

-- Indentation
opt.expandtab      = true
opt.tabstop        = 2
opt.shiftwidth     = 2
opt.softtabstop    = 2
opt.smartindent    = false
opt.breakindent    = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = false
opt.incsearch      = true
opt.inccommand     = "split"

-- Wrapping & Navigation
opt.wrap           = false
opt.linebreak      = true
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.splitright     = true
opt.splitbelow     = true

-- Performance & Completion
opt.lazyredraw     = true
opt.updatetime     = 250
opt.timeoutlen     = 300
opt.ttimeoutlen    = 10
opt.redrawtime     = 1500
opt.completeopt    = { "menu", "menuone", "noselect" }

-- File Handling
opt.autoread       = true
opt.autowrite      = true
opt.hidden         = true
opt.tags           = { "./tags;", "tags;" }

opt.shortmess:append("c")
opt.cinwords:append("Assert,PushStruct, internal, arena, Arena")

vim.cmd("packadd! matchit")
