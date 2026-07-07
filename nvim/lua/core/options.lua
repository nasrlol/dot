opt = vim.opt
g = vim.g
o = vim.o

g.mapleader = " "
g.maplocalleader = " "
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

opt.path:append("include/**")
opt.path:append("src/**")
opt.path:append("source/**")
opt.path:append("/usr/include")
opt.path:append("/usr/local/include")
opt.signcolumn     = "no"
opt.number         = false
opt.relativenumber = false
opt.cursorline     = true
opt.termguicolors  = true
opt.showmode       = false

g.autocomplete = true

opt.wildmenu = true
opt.wildmode = { "longest", "list", "full" }
opt.cmdheight = 2
opt.splitkeep = "screen"
opt.equalalways = true
opt.linespace      = 0
opt.showtabline    = 1
opt.laststatus     = 3
opt.pumheight      = 12
opt.list           = false
opt.fillchars      = { eob = " " }
opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
opt.cindent = true
opt.cinoptions = { "l1", "g0", "t0", "(0", "ws1", "N-s", "j1" }
opt.copyindent = true
opt.preserveindent = true
opt.backspace = "indent,eol,start"
opt.mouse = ""
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.virtualedit = "all"
opt.iskeyword:remove({"_",";", ".", ",", "(", ")", "[", "]", "{", "}", "*", "&", "+", "-" })
opt.formatoptions:remove({ "c", "r", "o" })

-- what in the magic=
opt.errorformat = "%f:%l:%c: %t%*[^:]: %m"
opt.commentstring = "// %s"

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "folds", "help", "localoptions" }
opt.expandtab = true
opt.tabstop = 1
opt.shiftwidth = 1
opt.softtabstop = 1
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
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.redrawtime = 1500
opt.completeopt = { "menu", "menuone" }
opt.complete = ".,b,t"
opt.autoread = true
opt.autowrite = true
opt.hidden = true
opt.tags = { "./tags;", "tags;" }
opt.shada = "!,'100,<50,s10,h"
opt.shortmess:append("I")
opt.cinwords:append("Assert,PushStruct,internal,arena,Arena")
