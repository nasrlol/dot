return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = false,
      region_check_events = "CursorMoved",
      delete_check_events = "TextChanged",
    })

    -- Optional: load snippet sources (comment out if unused)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })
  end,
}
