local map = vim.keymap.set
local ls = require("luasnip")


-- compile and see errors
map("n", "<M-b>", function()
    -- Close any existing vertical split on the right
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= vim.api.nvim_get_current_win() then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Run makeprg, capture output into quickfix
    local makeprg = vim.o.makeprg
    vim.cmd("cex system('" .. makeprg .. " 2>&1')")

    -- Open a vertical quickfix window taking up half the screen
    local half = math.floor(vim.o.columns / 2)
    vim.cmd("vert copen " .. half)
    vim.cmd("vertical resize " .. half)
end, { desc = "Run makeprg into vertical quickfix" })

-- exit terminal mode was broken before

map({"i", "s"}, "<Tab>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then ls.expand_or_jump() else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })

-- TODO(nasr): i still havent figured out a good way to do this or when it's honestly somewhat usefull
 map("i", "<M-n>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
        return ""
    end
    return "<C-n>"
end, { expr = true, desc = "Complete / snippet / indent" })

-- source config
map("n", "<leader>so", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })

-- super write
map("c", "w!!", function()
  vim.cmd("w !sudo tee % > /dev/null")
  vim.cmd("edit!")
end, { desc = "Write file with sudo" })
