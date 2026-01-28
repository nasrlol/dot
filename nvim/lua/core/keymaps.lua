local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>z")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>p", "\"_dP")
map("n", "<leader>p", "\"_dP")

map("n", "Q", "<nop>")
map("n", "q", "<nop>")

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "Force quit" })

map("n", "<leader>nt", "vim.")

-- Oil
map("n", "<leader>ex", "<cmd>Oil<cr>", { desc = "Oil file explorer" })

-- TODO(nasr): remove this ugly thing
map({"n"}, "<leader>mm",  "<cmd>%!clang-format<cr>", { desc = "format" })

-- Diagnostics
map("n", "nr", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "pr", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

map("n", "<leader>or", vim.diagnostic.open_float,
{ desc = "Diagnostic float" })

map("n", "<leader>qr", vim.diagnostic.setloclist,
{ desc = "Diagnostics → loclist" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Splits
map("n", "<leader>vt", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ht", "<cmd>split<cr>", { desc = "Horizontal split" })


-- Config
map("n", "<leader>con", "<cmd>vsplit $MYVIMRC<cr>", { desc = "Edit init.lua" })

-- Clipboard
map("n", "<leader>yb", "<cmd>%y+<cr>", { desc = "Yank whole buffer" })

-- Terminal
map("n", "<leader>tt", "<cmd>vertical terminal<cr>", { desc = "Yank whole buffer" })

map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "LSP: Go to type definition" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })


map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })

map("n", "<leader>ra", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>rf", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Document diagnostics" })

map("n", "<leader>un", "<cmd>FzfLua command_history<cr>", { desc = "Command history" })
map("n", "<leader>cs", "<cmd>FzfLua colorschemes<cr>", { desc = "Colorschemes" })
map("n", "<leader>man", "<cmd>FzfLua manpages<cr>", { desc = "Man pages" })

local diagnostics_active = true

map("n", "<leader>td", function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end, { desc = "Toggle diagnostics" })



-- Reload nvim
map("n", "<leader>so", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^ui") or name:match("^plugins") or name:match("^tools") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)  -- Use dofile instead of source
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload all Lua config" })
