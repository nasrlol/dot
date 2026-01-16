local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })
map("n", "<leader>ex", "<cmd>Oil<cr>", { desc = "Oil file explorer" })

-- Disable arrow keys
for _, mode in ipairs({ "n", "i", "v"}) do
  map(mode, "<Up>", "<Nop>")
  map(mode, "<Down>", "<Nop>")
  map(mode, "<Left>", "<Nop>")
  map(mode, "<Right>", "<Nop>")
end

-- Neovide (guarded)
if vim.g.neovide then
  map("n", "<C-+>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end, { silent = true })

  map("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end, { silent = true })

  map("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1.0
  end, { silent = true })

  map("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { silent = true })
end

-- Diagnostics
map("n", "nr", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "pr", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

map("n", "<leader>or", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>qr", vim.diagnostic.setloclist, { desc = "Diagnostics → loclist" })

local diagnostics_active = true
map("n", "<leader>td", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, { desc = "Toggle diagnostics" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Splits
map("n", "<leader>vt", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ht", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Search
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Terminal
map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- LSP global commands
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
map("n", "<leader>ll", "<cmd>LspLog<cr>", { desc = "LSP log" })

-- Config
map("n", "<leader>con", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit init.lua" })
local function reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match("^user") or name:match("^config") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end

map("n", "<leader>so", reload_config, { desc = "Reload all Lua config" })

-- Clipboard
map("n", "<leader>yb", "<cmd>%y+<cr>", { desc = "Yank whole buffer" })
