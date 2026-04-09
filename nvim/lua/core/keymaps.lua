local map = vim.keymap.set
local fzf = require("fzf-lua")

map("n", "<M-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<M-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<M-Left>",  "<cmd>vertical resize +2<cr>", { desc = "Decrease width" })
map("n", "<M-Right>", "<cmd>vertical resize -2<cr>", { desc = "Increase width" })

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

-- generate ctags
map("n", "<M-c>", "<cmd>!ctags -R<cr>", {  noremap = true, silent = true, desc = "generate ctags"  })

-- jump to tag
map("n", "gd", "<C-]>", { desc = "Jump to tag/definition" })

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

-- center cursor when using teleportation
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzz")
map("n", "N", "Nzz")

-- i keep forgetting i have these!!
map("n", "<M-r>", ":%s/\\v", { desc = "Search & Replace (Global)" })
map("v", "<M-r>", ":s/\\v",  { desc = "Search & Replace (Selection)" })

-- cuz its ez
map("n", "<leader>w",  "<cmd>w<cr>",           { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",           { desc = "Quit" })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- open oil 
map("n", "-", "<cmd>Oil<cr>",         { desc = "Open Oil" })

map("n", "<leader>bn", "<cmd>bnext<cr>",       { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>",   { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",    { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>",  { desc = "Close other buffers" })

 -- Disable default C-w
vim.keymap.set('n', '<C-w>', '<Nop>', { noremap = true })

-- fzf lua
map("n", "<leader>cd", fzf.zoxide,                        { noremap = true, silent = true, desc = "Zoxide" })
map("n", "<leader>tg", fzf.tags,                          { noremap = true, silent = true, desc = "Tags" })
map("n", "<M-p>",      fzf.files,                         { noremap = true, silent = true, desc = "Files" })
map("n", "<M-f>",      fzf.grep,                          { noremap = true, silent = true, desc = "Grep project" })
map("n", "<M-g>",      fzf.grep_curbuf,                   { noremap = true, silent = true, desc = "Grep buffer" })
map("n", "<M-s>",      fzf.grep_cword,                    { noremap = true, silent = true, desc = "Grep word under cursor" })
map("n", "<M-e>",      fzf.live_grep_native,                    { noremap = true, silent = true, desc = "fast grep" })

