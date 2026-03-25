opt   = vim.opt
g     = vim.g
o     = vim.o

-- PROVIDERS
g.mapleader = " "
g.maplocalleader = " "

g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_rubyprovider = 0

-- DISPLAY & COLORS
opt.termguicolors   = true
opt.signcolumn      = "no"
opt.number          = false
opt.numberwidth     = 1
opt.relativenumber  = false
opt.cursorline      = false
opt.showmode        = true
opt.list            = true

opt.fillchars = { eob = " ", }
opt.listchars = { tab = "_ ", trail = "."}

-- UI
if vim.g.neovide then
    opt.cmdheight = 1
    opt.cmdwinheight = 1

    opt.winbar = "%=%m %f%="
    opt.statusline = " %{mode()} %f%m%r %=%l:%c/%L [%Y] [%{&encoding}]"

    opt.laststatus = 2
    opt.showtabline = 2
else
    opt.winbar = ""
    opt.statusline = " %{mode()} %f%m%r %=%l:%c/%L [%Y] [%{&encoding}]"

    opt.cmdheight = 1
    opt.laststatus = 2
    opt.showtabline = 0
end


-- COMPLETION
o.autocomplete = true

opt.completeopt = { "noselect" }
opt.complete = ".,b,t"
opt.pumheight = 0
--

-- LAYOUT & SPLITS

opt.splitkeep       = "screen"
opt.equalalways     = true
opt.splitright      = true
opt.splitbelow      = true

-- INDENTATION
opt.cindent         = false
opt.cinoptions      = {}
opt.copyindent      = false
opt.preserveindent  = false
opt.expandtab       = true
opt.tabstop         = 4
opt.shiftwidth      = 4
opt.softtabstop     = 4
opt.smartindent     = false
opt.breakindent     = true
opt.autoindent      = true

-- SEARCH
opt.ignorecase      = true
opt.smartcase       = true
opt.hlsearch        = false
opt.incsearch       = true
opt.inccommand      = "split"

-- wrapping & scrolling
opt.smoothscroll = false
opt.wrap = false
opt.linebreak = false
opt.scrolloff = 0
opt.sidescrolloff = 10
opt.scroll = 0
opt.scrolljump = -100

-- editing
opt.backspace = "indent,eol,start"
opt.mouse = "n"
opt.clipboard = "unnamedplus"
opt.virtualedit = "all"

-- files & persistence
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.autoread = true
opt.autowrite = true
opt.hidden = true

-- PERFORMANCE
opt.lazyredraw  = true
opt.updatetime  = 250
opt.timeoutlen  = 500
opt.ttimeoutlen = 0
opt.redrawtime  = 1500

opt.exrc = true
opt.secure = true


-- FORMATTING & COMMENTS
opt.errorformat         = "%f:%l:%c: %t%*[^:]: %m"
opt.commentstring       = "// %s"
opt.formatoptions:remove({ "c", "r", "o" })

-- PATH & INCLUDES
opt.path:append("include/**")
opt.path:append("src/**")
opt.path:append("source/**")
opt.path:append("/usr/include")
opt.path:append("/usr/local/include")

opt.signcolumn     = "yes:1"
opt.number         = true
opt.relativenumber = false
opt.cursorline     = true
opt.termguicolors  = true
opt.showmode       = false

opt.wildmenu = true
opt.wildmode = { "longest", "list", "full" }
opt.cmdheight = 2

opt.splitkeep = "screen"
opt.equalalways = true

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

opt.mouse = ""
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

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "folds", "help", "localoptions" }

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
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.redrawtime = 1500
opt.completeopt = { "menu", "menuone", "noselect" }

opt.autoread = true
opt.autowrite = true
opt.hidden = true
opt.tags = { "./tags;", "tags;" }
opt.shada = "!,'100,<50,s10,h"
opt.shortmess:append("c")

-- KEYWORDS & SYNTAX
opt.iskeyword:remove({"_"})
opt.cinwords:append("Assert,PushStruct,internal,arena,Arena")


-- SESSION & TAGS
opt.tags = { "./tags;", "tags;" }
opt.shada = "!,'100,<50,s10,h"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "winpos", "folds", "help", "localoptions" }
opt.shortmess:append("I")
