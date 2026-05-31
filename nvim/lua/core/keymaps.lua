local fzf = require("fzf-lua")
local ls = require("luasnip")

local diagnostic    = vim.diagnostic
local lsp           = vim.lsp.buf
local map           = vim.keymap.set

local o = vim.o
local g = vim.g

map("n", "<C-=>", function()
    fontsize = fontsize + 1
    set_fontsize()
end)

map("n", "<C-->", function()
    fontsize = fontsize - 1
    set_fontsize()
end)

map("n", "<F11>", function()
g.neovide_fullscreen = not g.neovide_fullscreen
end, { desc = "Toggle Neovide fullscreen" })

----------------------------------------------------------------------------
map("n", "<M-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<M-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<M-Left>",  "<cmd>vertical resize +2<cr>", { desc = "Decrease width" })
map("n", "<M-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase width" })

map("n", "<M-h>", "<C-w>h")
map("n", "<M-j>", "<C-w>j")
map("n", "<M-k>", "<C-w>k")
map("n", "<M-l>", "<C-w>l")

if false then
    map("n", "<C-u>", "<C-b>")
    map("n", "<C-d>", "<C-f>")
end

-- generate ctags
map("n", "<M-c>", "<cmd>!ctags -R<cr>", {  noremap = true, silent = true, desc = "generate ctags"  })


-- basic window splits
map("n", "<leader>v",  "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h",  "<cmd>split<cr>",  { desc = "Horizontal split" })

-- tab stuff i never use
map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Prev tab" })

----------------------------------------------------------------------------
-- primaegan cool
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

map("v", "<", "<gv")
map("v", ">", ">gv")

map({"n", "x"}, "<leader>p", [["_dP]], { desc = "Paste (keep register)" })
----------------------------------------------------------------------------

-- i keep forgetting i have these!!
map("n", "<M-r>", ":%s/\\v", { desc = "Search & Replace (Global)" })
map("v", "<M-r>", ":s/\\v",  { desc = "Search & Replace (Selection)" })

-- cuz its ez
map("n", "<leader>w",  "<cmd>w<cr>",           { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",           { desc = "Quit" })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- open oil
map("n", "<M-->", "<cmd>Oil<cr>",         { desc = "Open Oil" })

map("n", "<leader>bn", "<cmd>bnext<cr>",       { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>",   { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",    { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close other buffers" })

-- Disable default C-w
map('n', '<C-w>', '<Nop>', { noremap = true })

-- neovide
map("n", "<F11>", function()
g.neovide_fullscreen = not g.neovide_fullscreen
end, { desc = "Toggle Neovide fullscreen" })


-- fzf lua
map("n", "<leader>cd", fzf.zoxide,                        { noremap = true, silent = true, desc = "Zoxide" })
map("n", "<leader>tg", fzf.tags,                          { noremap = true, silent = true, desc = "Tags" })
map("n", "<M-p>",      fzf.files,                         { noremap = true, silent = true, desc = "Files" })
map("n", "<M-f>",      fzf.grep,                          { noremap = true, silent = true, desc = "Grep project" })
map("n", "<M-g>",      fzf.grep_curbuf,                   { noremap = true, silent = true, desc = "Grep buffer" })
map("n", "<M-s>",      fzf.grep_cword,                    { noremap = true, silent = true, desc = "Grep word under cursor" })
map("n", "<M-e>",      fzf.live_grep_native,              { noremap = true, silent = true, desc = "fast grep" })
map("n", "<M-a>",      fzf.diagnostics_workspace,         { noremap = true, silent = true, desc = "workspace diagnostics" })

map('n', 'q', '<Nop>')

map('n', 'gd', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        vim.lsp.buf.definition()
    else
        vim.cmd('tag ' .. vim.fn.expand('<cword>'))
    end
end)

-- lsp
map("n", "<C-e>",       diagnostic.open_float,   { desc = "Open diagnostic float" })
map("n", "<M-n>",       diagnostic.goto_next,   { desc = "Next diagnostic" })
map("n", "[d",          diagnostic.goto_prev,    { desc = "Prev diagnostic" })
map("n", "<C-l>",       diagnostic.setloclist,   { desc = "Diagnostic loclist" })
map("n", "<leader>ca",  lsp.code_action,         { desc = "Code action" })
map("n", "<leader>rn",  lsp.rename,              { desc = "Rename" })
map("n", "K",           lsp.hover,               { desc = "Hover" })

map("n", "<leader>yw", function()
    -- TODO(nasr): what does this function do?
  vim.fn.setreg("+", vim.fn.getcwd())
end)

map("n", "<leader>yf", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end)

map("n", "<leader>yr", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
end)

map("i", "<Tab>", function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = vim.api.nvim_get_current_line():sub(1, col)
    if not before:match("[%w_]+$") then
        return "<Tab>"
    end
    local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
    local keys = has_lsp and "<C-x><C-o>" or "<C-x><C-n>"
    return vim.api.nvim_replace_termcodes(keys .. "<C-y>", true, false, true)
end, { expr = true})

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

map({ "i", "s" }, "<Tab>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })




-- Insert current date/time like: # May 28 22:48 - nasr
map("n", "<leader>dt", function()
    local timestamp = os.date("%B %d %H:%M - nasr")
    vim.api.nvim_put({ timestamp }, "l", true, true)
end, { desc = "Insert timestamp with name" })
