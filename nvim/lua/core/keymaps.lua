local map = vim.keymap.set
local diagnostics_active = true
local fzf = require("fzf-lua")
local ls = require("luasnip")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows with arrow keys
map("n", "<M-Up>", "<C-w>+", { desc = "Increase window height" })
map("n", "<M-Down>", "<C-w>-", { desc = "Decrease window height" })
map("n", "<M-Left>", "<C-w><", { desc = "Decrease window width" })
map("n", "<M-Right>", "<C-w>>", { desc = "Increase window width" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Center screen on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz", { desc = "Next search, centered" })
map("n", "N", "Nzz", { desc = "Prev search, centered" })
map("n", "*", "*zz", { desc = "Search word, centered" })
map("n", "#", "#zz", { desc = "Search word back, centered" })

-- Paste without overwriting register
map("n", "<leader>p", "\"_dP")
map("x", "<leader>p", "\"_dP")

-- Disable Ex mode and macro keys
map("n", "Q", "<nop>")
map("n", "q", "<nop>")

-- Better indentation
map("v", "<", "<gv")
map("v", ">", ">gv")

-- FILE & BUFFER MANAGEMENT
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })

-- Oil file explorer
map("n", "<C-x><C-f>", "<cmd>Oil<cr>", { desc = "Oil file explorer" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<cr>", { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#<cr>", { desc = "Close all buffers except current" })

-- Splits
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tm", "<cmd>tabmove<cr>", { desc = "Move tab" })

-- Terminal
map("n", "<leader>tt", "<cmd>vertical terminal<cr>", { desc = "Vertical terminal" })
map("n", "<leader>tT", "<cmd>terminal<cr>", { desc = "Horizontal terminal" })

-- Config
map("n", "<leader>con", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit init.lua" })

-- Clipboard
map("n", "<leader>yb", "<cmd>%y+<cr>", { desc = "Yank whole buffer" })

-- Search & Replace
map("n", "<leader>sr", ":%s///g<Left><Left><Left>", { desc = "Search & replace all" })
map("v", "<leader>sr", ":s///g<Left><Left><Left>", { desc = "Search & replace selection" })

-- DIAGNOSTICS
map("n", "nr", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "pr", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

map("n", "<leader>or", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>qr", vim.diagnostic.setloclist, { desc = "Diagnostics → loclist" })

map("n", "<leader>td", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, { desc = "Toggle diagnostics" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: Go to type definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
map("n", "<leader>fm", vim.lsp.buf.format, { desc = "LSP: Format buffer" })

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })

-- File searching
map("n", "<leader><leader>", function() fzf.files() end, { desc = "󰈙 Find files" })
map("n", "<M-f>", function() fzf.files() end, { desc = "󰈙 Find files (Meta)" })

-- Live grep / search
map("n", "<leader>fa", function() fzf.live_grep() end, { desc = "󰊄 Live grep" })
map("n", "<M-a>", function() fzf.live_grep() end, { desc = "󰊄 Live grep (Meta)" })
map("n", "<leader>sa", function() fzf.live_grep() end, { desc = "󰊄 Search all" })

-- Grep with arguments
map("n", "<leader>sg", function() fzf.grep({ search = vim.fn.input("Grep: ") }) end, { desc = "󰊄 Grep with args" })

-- Resume last search
map("n", "<leader>sr", function() fzf.resume() end, { desc = "󰊄 Resume last search" })

-- Buffer management
map("n", "<leader>fb", function() fzf.buffers() end, { desc = "🗂️  Find buffers" })
map("n", "<M-b>", function() fzf.buffers() end, { desc = "🗂️  Find buffers (Meta)" })
map("n", "<leader>bb", function() fzf.buffers() end, { desc = "🗂️  Buffers" })

-- Help documentation
map("n", "<leader>fh", function() fzf.help_tags() end, { desc = "❓ Help tags" })
map("n", "<M-h>", function() fzf.help_tags() end, { desc = "❓ Help tags (Meta)" })
map("n", "<leader>/", function() fzf.help_tags() end, { desc = "❓ Help" })

-- Recent files / History
map("n", "<leader>fr", function() fzf.oldfiles() end, { desc = "🕐 Recent files" })
map("n", "<M-r>", function() fzf.oldfiles() end, { desc = "🕐 Recent files (Meta)" })

-- Diagnostics
map("n", "<leader>da", function() fzf.diagnostics_workspace() end, { desc = "⚠️  Workspace diagnostics" })
map("n", "<M-d>", function() fzf.diagnostics_workspace() end, { desc = "⚠️  Workspace diagnostics (Meta)" })
map("n", "<leader>dd", function() fzf.diagnostics_document() end, { desc = "⚠️  Document diagnostics" })

-- Command history
map("n", "<leader>ch", function() fzf.command_history() end, { desc = "📝 Command history" })
map("n", "<M-c>", function() fzf.command_history() end, { desc = "📝 Command history (Meta)" })

-- Colorschemes
map("n", "<leader>cs", function() fzf.colorschemes() end, { desc = "🎨 Colorschemes" })
map("n", "<M-t>", function() fzf.colorschemes() end, { desc = "🎨 Colorschemes (Meta)" })

-- Man pages
map("n", "<leader>hm", function() fzf.manpages() end, { desc = "📖 Manual pages" })

-- Git integration
map("n", "<leader>gc", function() fzf.git_commits() end, { desc = "🔀 Git commits" })
map("n", "<leader>gb", function() fzf.git_branches() end, { desc = "🌿 Git branches" })
map("n", "<leader>gs", function() fzf.git_status() end, { desc = "📊 Git status" })
map("n", "<leader>gf", function() fzf.git_files() end, { desc = "📁 Git files" })

-- LSP & Symbols
map("n", "<leader>km", function() fzf.keymaps() end, { desc = "⌨️  Keymaps" })
map("n", "<M-k>", function() fzf.keymaps() end, { desc = "⌨️  Keymaps (Meta)" })
map("n", "<leader>ls", function() fzf.lsp_document_symbols() end, { desc = "🔍 Document symbols" })
map("n", "<leader>lw", function() fzf.lsp_workspace_symbols() end, { desc = "🔍 Workspace symbols" })

-- Additional FZF
map("n", "<leader>lo", function() fzf.loclist() end, { desc = "📋 Location list" })
map("n", "<leader>qq", function() fzf.quickfix() end, { desc = "📋 Quickfix list" })


map({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
      "n",
      true
    )
  end
end, { silent = true, desc = "LuaSnip expand/jump" })

map({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return "<S-Tab>"
  end
end, { expr = true, silent = true, desc = "LuaSnip jump back" })

map({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "LuaSnip next choice" })

-- CONFIG MANAGEMENT
map("n", "<leader>so", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })

-- Toggle relative line numbers
map("n", "<leader>rn", function()
  vim.o.relativenumber = not vim.o.relativenumber
  vim.notify("Relative numbers: " .. tostring(vim.o.relativenumber), vim.log.levels.INFO)
end, { desc = "Toggle relative numbers" })

-- Toggle line wrapping
map("n", "<leader>ww", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Wrap: " .. tostring(vim.o.wrap), vim.log.levels.INFO)
end, { desc = "Toggle line wrap" })

-- Highlight current line/column
map("n", "<leader>hh", function()
  vim.o.cursorline = not vim.o.cursorline
  vim.notify("Cursor line: " .. tostring(vim.o.cursorline), vim.log.levels.INFO)
end, { desc = "Toggle cursor line" })

-- Copy file path
map("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path" })

-- Copy relative file path
map("n", "<leader>yr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy relative path" })
