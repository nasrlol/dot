-- Plugin manager
require("core.options")

require("core.lazy")

-- Core editor behavior
require("core.keymaps")

-- UI
require("ui.colors")
require("ui.fillchars")
require("ui.neovide")

require("ui.statusline")

require("core.autocmds")
require("core.lsp")
require("tools.build")
require("tools.build_wq").setup()
