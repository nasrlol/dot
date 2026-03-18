local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.path:append("include/**")
opt.path:append("src/**")
opt.path:append("source/**")
opt.path:append("/usr/include")
opt.path:append("/usr/local/include")

opt.signcolumn     = "no"
opt.number         = false
opt.relativenumber = false
opt.cursorline     = false
opt.termguicolors  = false
opt.showmode       = false
opt.cmdheight      = 0
opt.linespace      = 0
opt.showtabline    = 1
opt.laststatus     = 3
opt.pumheight      = 0
opt.list           = false
opt.fillchars      = { eob = " " }
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }

opt.cindent = true
opt.cinoptions = { "l1", "g0", "t0", "(0", "ws1", "N-s", "j1" }
opt.copyindent = true
opt.preserveindent = true
opt.backspace = "indent,eol,start"

opt.mouse = nil
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.virtualedit = "all"

opt.iskeyword:append("_")
opt.iskeyword:remove({ ";", ".", ",", "(", ")", "[", "]", "{", "}", "*", "&", "+", "-" })
opt.formatoptions:remove({ "c", "r", "o" })

opt.errorformat = "%f:%l:%c: %t%*[^:]: %m"
opt.commentstring = "// %s"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = false
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "split"

opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true

opt.lazyredraw = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.redrawtime = 1500
opt.completeopt = { "menu", "menuone", "noselect" }

opt.autoread = true
opt.autowrite = true
opt.hidden = true
opt.tags = { "./tags;", "tags;" }
opt.shada = "!,'100,<50,s10,h"
opt.shortmess:append("c")

opt.cinwords:append("Assert,PushStruct,internal,arena,Arena")

vim.cmd("packadd! matchit")
