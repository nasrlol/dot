-- Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "no"  -- Always show, prevents text shifting
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cmdheight = 1  -- Hide cmdline when not in use (Neovim 0.8+)

vim.opt.showtabline = 2
vim.opt.laststatus = 3  -- Global statusline

vim.opt.pumheight = 10  -- Limit popup menu height


-- Editing Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false  -- Disable backup files too

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2  -- Makes backspace delete indent properly
vim.opt.smartindent = true
vim.opt.breakindent = true  -- Wrapped lines maintain indent

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true  -- Highlight search results
vim.opt.incsearch = true  -- Show matches as you type

-- Wrapping
vim.opt.wrap = false
vim.opt.linebreak = true  -- If wrap is enabled, break at word boundaries

-- Navigation & Splits
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8  -- Horizontal scroll offset
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance
vim.opt.updatetime = 250  -- Faster completion & CursorHold events
vim.opt.timeoutlen = 300  -- Faster key sequence timeout
vim.opt.redrawtime = 1500  -- Time to wait for redraw
vim.opt.ttimeoutlen = 10  -- Faster key code timeout

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10  -- Max items in completion popup

-- File Handling
vim.opt.autoread = true  -- Auto reload files changed outside vim
vim.opt.hidden = true  -- Allow hidden buffers

-- Misc
vim.opt.tags = { "./tags;", "tags;" }
vim.opt.iskeyword:remove("_")  -- Treat underscore as word boundary
vim.opt.formatoptions:remove({ "c", "r", "o" })  -- Don't auto-insert comments
vim.opt.shortmess:append("c")  -- Don't show completion messages
vim.opt.fillchars = { eob = " " }  -- Remove ~ from empty lines
vim.opt.list = true  -- Show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
