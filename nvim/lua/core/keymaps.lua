local fzf = require("fzf-lua")

map("n", "<M-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<M-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<M-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

if  vim.g.neovide then
    map("n", "<M-h>", "<C-w>h")
    map("n", "<M-j>", "<C-w>j")
    map("n", "<M-k>", "<C-w>k")
    map("n", "<M-l>", "<C-w>l")
else 
    map("n", "<C-h>", "<C-w>h")
    map("n", "<C-j>", "<C-w>j")
    map("n", "<C-k>", "<C-w>k")
    map("n", "<C-l>", "<C-w>l")
end


map("n", "<M-c>", "<cmd>!ctags -R<cr>", {  noremap = true, silent = true, desc = "generate ctags"  })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>v", "<cmd>vsplit<cr>",  { desc = "Vertical split" })
map("n", "<leader>h", "<cmd>split<cr>",   { desc = "Horizontal split" })

-- EDITING ---------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" })
map("v", "<", "<gv", { desc = "Indent left (keep selection)" })
map("v", ">", ">gv", { desc = "Indent right (keep selection)" })
map({ "n", "x" }, "<leader>p", [["_dP]], { desc = "Paste (keep register)" })

-- SEARCH & REPLACE ------------------------------------------------------
map("n", "<M-r>", ":%s/\\v",  { desc = "Search & Replace (Global)" })
map("v", "<M-r>", ":s/\\v",   { desc = "Search & Replace (Selection)" })

-- FILE ------------------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>",  { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })
map("n", "<M-->",     "<cmd>Oil<cr>", { desc = "Open Oil" })

map("n", "<leader>R", ":%s/\\v", { desc = "Search & Replace (Global)" })
map("v", "<leader>R", ":s/\\v",  { desc = "Search & Replace (Selection)" })


-- cuz its ez
map("n", "<leader>w",  "<cmd>w<cr>",           { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",           { desc = "Quit" })

-- oil stuff
map("n", "<C-x><C-f>", "<cmd>Oil<cr>",         { desc = "Open Oil" })
map("n", "-", "<cmd>Oil<cr>",         { desc = "Open Oil" })

-- BUFFERS ---------------------------------------------------------------
map("n", "<leader>bn", "<cmd>bnext<cr>",       { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>",   { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",    { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close other buffers" })

map("n", "<leader>cd", fzf.zoxide,                        { noremap = true, silent = true, desc = "Zoxide" })
map("n", "<leader>tg", fzf.tags,                          { noremap = true, silent = true, desc = "Tags" })
map("n", "<leader>fc", fzf.commands,                      { noremap = true, silent = true, desc = "Commands" })
map("n", "<M-f>",      fzf.grep,                          { noremap = true, silent = true, desc = "Grep project" })
map("n", "<M-p>",      fzf.files,                         { noremap = true, silent = true, desc = "Files" })
map("n", "<M-g>",      fzf.grep_curbuf,                   { noremap = true, silent = true, desc = "Grep buffer" })
map("n", "<M-s>",      fzf.grep_cword,                    { noremap = true, silent = true, desc = "Grep word under cursor" })



map("n", "<leader>tr", "<cmd>set rnu!<cr>",  { desc = "Toggle relative numbers" })
map("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })

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



map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map("n", "gd", "<C-]>", { desc = "Jump to tag/definition" })

map({"i", "s"}, "<S-Tab>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })

map({"i", "s"}, "<Tab>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then ls.expand_or_jump() else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })


-- Built-in ins-completion
map("i", "<C-n>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-n>"
end, { expr = true, desc = "Next completion / open buffer completion" })

map("i", "<C-p>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-x><C-p>"
end, { expr = true, desc = "Prev completion / open buffer completion" })

map("i", "<C-]>", "<C-x><C-]>", { desc = "Tag completion" })

map("i", "<Esc>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><Esc>" or "<Esc>"
end, { expr = true, desc = "Close popup / exit insert" })


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


-- source
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
