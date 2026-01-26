-- Plugin manager
require("core.lazy")

-- Core editor behavior
require("core.options")
require("core.keymaps")

-- UI
require("ui.colors")
require("ui.fillchars")
require("ui.neovide")

require("ui.statusline")



-- Plugins
require("plugins.oil")
require("plugins.cmp")
require("plugins.fzf")
require("core.autocmds")
require("tools.build")
require("tools.build_without_quickfix").setup()


