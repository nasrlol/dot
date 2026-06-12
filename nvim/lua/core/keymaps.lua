local fzf = require("fzf-lua")
local ls  = require("luasnip")

local diagnostic = vim.diagnostic
local lsp        = vim.lsp.buf
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

-- Window navigation — C-hjkl is shared with tmux via vim-tmux-navigator.
-- C-l is intentionally NOT mapped here; tmux handles the passthrough.
-- <C-\><C-n> + C-h/j/k/u for terminal pane nav is handled by the plugin.
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
-- <C-l> — NOT bound here. Use <leader>l or tmux passthrough for clear-screen.
--         vim-tmux-navigator registers <C-l> itself when loaded.

map("n", "<leader>v", "<cmd>vsplit<cr>",  { desc = "Vertical split" })
map("n", "<leader>h", "<cmd>split<cr>",   { desc = "Horizontal split" })

-- TABS (rarely used but kept) -------------------------------------------
map("n", "<leader>to", "<cmd>tabnew<cr>",     { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>",   { desc = "Close tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>",    { desc = "Next tab" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Prev tab" })

-- EDITING ---------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" })

map("v", "<", "<gv", { desc = "Indent left (keep selection)" })
map("v", ">", ">gv", { desc = "Indent right (keep selection)" })

map({ "n", "x" }, "<leader>p", [["_dP]], { desc = "Paste (keep register)" })

-- SEARCH & REPLACE ------------------------------------------------------
map("n", "<D-r>", ":%s/\\v",  { desc = "Search & Replace (Global)" })
map("v", "<D-r>", ":s/\\v",   { desc = "Search & Replace (Selection)" })

-- CTAGS -----------------------------------------------------------------
map("n", "<D-c>", "<cmd>!ctags -R<cr>", { noremap = true, silent = true, desc = "Generate ctags" })

-- FILE ------------------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>",  { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })
map("n", "<D-->",     "<cmd>Oil<cr>", { desc = "Open Oil" })

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
map("n", "<D-p>",      fzf.files,                { noremap = true, silent = true, desc = "Files" })
map("n", "<D-f>",      fzf.grep,                 { noremap = true, silent = true, desc = "Grep project" })
map("n", "<D-g>",      fzf.grep_curbuf,          { noremap = true, silent = true, desc = "Grep buffer" })
map("n", "<D-s>",      fzf.grep_cword,           { noremap = true, silent = true, desc = "Grep word under cursor" })
map("n", "<D-e>",      fzf.live_grep_native,     { noremap = true, silent = true, desc = "Fast grep" })
map("n", "<D-a>",      fzf.diagnostics_workspace, { noremap = true, silent = true, desc = "Workspace diagnostics" })

-- LSP -------------------------------------------------------------------
map("n", "gd", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
        vim.lsp.buf.definition()
    else
        vim.cmd("tag " .. vim.fn.expand("<cword>"))
    end
end, { desc = "Go to definition (LSP or ctags)" })

map("n", "<C-e>",      diagnostic.open_float, { desc = "Open diagnostic float" })
map("n", "<D-n>",      diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "[d",         diagnostic.goto_prev,  { desc = "Prev diagnostic" })
-- <C-l> for setloclist removed — conflicts with pane-right nav.
-- Use <leader>dl instead:
map("n", "<leader>dl", diagnostic.setloclist, { desc = "Diagnostic loclist" })
map("n", "<leader>ca", lsp.code_action,       { desc = "Code action" })
map("n", "<leader>rn", lsp.rename,            { desc = "Rename" })
map("n", "K",          lsp.hover,             { desc = "Hover" })

-- YANK UTILS ------------------------------------------------------------
map("n", "<leader>yw", function()
    -- yank current working directory path
    vim.fn.setreg("+", vim.fn.getcwd())
end, { desc = "Yank cwd" })

map("n", "<leader>yf", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Yank absolute file path" })

map("n", "<leader>yr", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Yank relative file path" })

-- COMPLETION & SNIPPETS -------------------------------------------------
-- Single <Tab> handler for insert mode: omnifunc → native → snippet expand.
-- (Removed duplicate definition that was below.)
map("i", "<Tab>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
        return ""
    end
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = vim.api.nvim_get_current_line():sub(1, col)
    if not before:match("[%w_]+$") then
        return "<Tab>"
    end
    local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
    local keys = has_lsp and "<C-x><C-o>" or "<C-x><C-n>"
    return vim.api.nvim_replace_termcodes(keys .. "<C-y>", true, false, true)
end, { expr = true, silent = true, desc = "Tab: snippet / omni / native complete" })

-- <Tab> in select mode for snippet jump-forward
map("s", "<Tab>", function()
    if ls.jumpable(1) then ls.jump(1) end
end, { silent = true, desc = "Snippet jump forward" })

map("i", "<D-n>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
        return ""
    end
    return "<C-n>"
end, { expr = true, desc = "Complete / snippet next" })

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
