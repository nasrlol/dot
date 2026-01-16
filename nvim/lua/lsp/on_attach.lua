return function(_, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr }

  -- LSP navigation
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K",  vim.lsp.buf.hover, opts)

  -- Split / tab variants
  map("n", "gD", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
  end, opts)

  map("n", "gT", function()
    vim.cmd("tabnew")
    vim.lsp.buf.definition()
  end, opts)

  -- Actions
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end
