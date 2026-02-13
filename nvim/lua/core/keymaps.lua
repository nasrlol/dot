local map = vim.keymap.set
local fzf = require("fzf-lua")
local ls = require("luasnip")

-- Move between windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<M-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase height" })
map("n", "<M-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease height" })
map("n", "<M-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Splits & Tabs
map("n", "<leader>v",  "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h",  "<cmd>split<cr>",  { desc = "Horizontal split" })
map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Prev tab" })

-- Move lines in Visual Mode
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Better indentation (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Keeping it centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Paste without losing register
map({"n", "x"}, "<leader>p", [["_dP]], { desc = "Paste (keep register)" })

-- Search & Replace (Fixed conflict with fzf.resume)
map("n", "<leader>R", ":%s/\\v", { desc = "Search & Replace (Global)" })
map("v", "<leader>R", ":s/\\v",  { desc = "Search & Replace (Selection)" })

map("n", "<leader>w",  "<cmd>w<cr>",  { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<cr>",  { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<cr>", { desc = "Force quit all" })
map("n", "<C-x><C-f>", "<cmd>Oil<cr>", { desc = "Open Oil" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>",  { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

map("n", "<leader><leader>", fzf.files, { desc = "Find files" })
map("n", "<leader>fa", fzf.live_grep,    { desc = "Live grep" })
map("n", "<leader>fb", fzf.buffers,      { desc = "Buffers" })
map("n", "<leader>fr", fzf.oldfiles,     { desc = "Recent files" })
map("n", "<leader>gs", fzf.git_status,   { desc = "Git status" })
map("n", "<leader>sr", fzf.resume,       { desc = "Resume last search" })

-- Diagnostic Toggles
local diagnostics_active = true
map("n", "<leader>td", function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then vim.diagnostic.show() else vim.diagnostic.hide() end
end, { desc = "Toggle diagnostics" })


map({"i", "s"}, "<Tab>", function()
    if ls.expand_or_jumpable() then ls.expand_or_jump() else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })

map({"i", "s"}, "<S-Tab>", function() if ls.jumpable(-1) then ls.jump(-1) end end, { silent = true })

map("n", "<leader>tr", "<cmd>set rnu!<cr>", { desc = "Toggle relative numbers" })
map("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })
map("n", "<leader>yp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

map("n", "<leader>so", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })

