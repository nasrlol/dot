local fzf = require("fzf-lua")

local diagnostic = vim.diagnostic
local map        = vim.keymap.set
local g          = vim.g

-- NEOVIDE ---------------------------------------------------------------
-- (single definition — was duplicated)
map("n", "<F11>", function()
    g.neovide_fullscreen = not g.neovide_fullscreen
end, { desc = "Toggle Neovide fullscreen" })

-- SPLITS & RESIZE -------------------------------------------------------
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize +2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase width" })

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

-- TERMINAL --------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- BUFFERS ---------------------------------------------------------------
map("n", "<leader>bn", "<cmd>bnext<cr>",       { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>",   { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",    { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close other buffers" })

-- Disable accidental C-w close
map("n", "<C-w>", "<Nop>", { noremap = true })
-- Disable accidental q (macro record)
map("n", "q", "<Nop>")

-- FZF-LUA ---------------------------------------------------------------
map("n", "<leader>cd", fzf.zoxide,               { noremap = true, silent = true, desc = "Zoxide" })
map("n", "<leader>tg", fzf.tags,                 { noremap = true, silent = true, desc = "Tags" })
map("n", "<M-p>",      fzf.files,                { noremap = true, silent = true, desc = "Files" })
map("n", "<M-f>",      fzf.grep,                 { noremap = true, silent = true, desc = "Grep project" })
map("n", "<M-g>",      fzf.grep_curbuf,          { noremap = true, silent = true, desc = "Grep buffer" })
map("n", "<M-s>",      fzf.grep_cword,           { noremap = true, silent = true, desc = "Grep word under cursor" })
map("n", "<M-e>",      fzf.live_grep_native,     { noremap = true, silent = true, desc = "Fast grep" })
map("n", "<M-a>",      fzf.diagnostics_workspace, { noremap = true, silent = true, desc = "Workspace diagnostics" })

-- CONFIG RELOAD ---------------------------------------------------------
map("n", "<leader>so", function()
    for name, _ in pairs(package.loaded) do
        if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })

-- TIMESTAMP -------------------------------------------------------------
map("n", "<leader>dt", function()
    local timestamp = os.date("%B %d %H:%M - nasr")
    vim.api.nvim_put({ timestamp }, "l", true, true)
end, { desc = "Insert timestamp with name" })
