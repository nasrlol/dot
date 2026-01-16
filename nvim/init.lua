vim.cmd([[

colorscheme retrobox
filetype plugin indent on

]])

-- Plugin manager
require("core.lazy")

-- Core editor behavior
require("core.options")
require("core.keymaps")

-- UI
require("ui.colors")
require("ui.fillchars")
require("ui.neovide")

-- Plugins
require("plugins.oil")
require("plugins.cmp")
require("plugins.fzf")

-- LSP
require("lsp.clangd")

require("core.autocmds")

-- Tools / custom utilities
require("tools.build").setup()
