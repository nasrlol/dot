local map = vim.keymap.set
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

map("n", "<leader>v",  "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h",  "<cmd>split<cr>",  { desc = "Horizontal split" })
map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Prev tab" })

map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

map({"n", "x"}, "<leader>p", [["_dP]], { desc = "Paste (keep register)" })

map("n", "<leader>R", ":%s/\\v", { desc = "Search & Replace (Global)" })
map("v", "<leader>R", ":s/\\v",  { desc = "Search & Replace (Selection)" })

map("n", "<leader>w",  "<cmd>w<cr>",           { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",           { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>",         { desc = "Force quit all" })
map("n", "<C-x><C-f>", "<cmd>Oil<cr>",         { desc = "Open Oil" })

map("n", "<leader>bn", "<cmd>bnext<cr>",       { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>",   { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",    { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close other buffers" })

map("n", "<leader>fr"      , fzf.oldfiles,     { noremap = true, silent = true, desc = "Recent files" })
map("n", "<leader>sr"      , fzf.resume,       { noremap = true, silent = true, desc = "Resume search" })
map("n", "<leader>cd"      , fzf.zoxide,       { noremap = true, silent = true, desc = "Zoxide" })
map("n", "<leader>tg"      , fzf.tags,         { noremap = true, silent = true, desc = "Tags" })
map("n", "<leader>fc"      , fzf.commands,     { noremap = true, silent = true, desc = "Commands" })
map("n", "<M-m>"           , fzf.manpages,     { noremap = true, silent = true, desc = "Man pages" })
map("n", "<M-f>"           , fzf.grep,         { noremap = true, silent = true, desc = "grep" })
map("n", "<M-p>"           , fzf.files,        { noremap = true, silent = true, desc = "Files" })
map("n", "<M-b>"           , fzf.buffers,      { noremap = true, silent = true, desc = "Buffers" })
map("n", "<M-g>"           , fzf.grep_curbuf,  { noremap = true, silent = true, desc = "Grep buffer" })

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
map("n", "<leader>so", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })

map("c", "w!!", function()
  vim.cmd("w !sudo tee % > /dev/null")
  vim.cmd("edit!")
end, { desc = "Write file with sudo" })
