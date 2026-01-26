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

vim.keymap.set({"n"}, "<leader>mm",  "<cmd>%!clang-format<cr>", { desc = "format" })

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
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- LSP global commands
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
map("n", "<leader>ll", "<cmd>LspLog<cr>", { desc = "LSP log" })

-- Config
map("n", "<leader>con", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit init.lua" })

map("n", "<leader>so", "<cmd>so ~/.config/nvim/init.lua<cr>", { desc = "Reload all Lua config" })

-- Clipboard
map("n", "<leader>yb", "<cmd>%y+<cr>", { desc = "Yank whole buffer" })

-- Clipboard
map("n", "<leader>tt", "<cmd>vertical terminal<cr>", { desc = "Yank whole buffer" })


-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })


-- View info
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })

-- Go to declaration (often different from definition in C/C++)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })

-- Go to type definition
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: Go to type definition" })


-- Go to implementation
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })

vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })


-- Rename symbol
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })

-- Code actions
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })



local function oil_open_project_here()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry then return end

  local dir
  if entry.type == "directory" then
    dir = oil.get_current_dir() .. entry.name
  else
    dir = oil.get_current_dir()
  end

  vim.fn.chdir(dir)
  oil.open(dir)
end

vim.keymap.set("n", "<leader>==", oil_open_project_here, { buffer = true })

vim.keymap.set("n", "<leader>lr", function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == "clangd" then
      vim.lsp.stop_client(client.id)
    end
  end

  vim.defer_fn(function()
    vim.cmd("LspStart clangd")
  end, 100)
end, { desc = "Restart clangd" })
