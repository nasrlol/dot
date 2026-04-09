vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd("packadd LuaSnip")

    local ls = require("luasnip")
    ls.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      region_check_events = "CursorMoved",
      delete_check_events = "TextChanged",
    })

    require("luasnip.loaders.from_lua").lazy_load({
      paths = "~/.config/nvim/snippets"
    })
  end,
})
