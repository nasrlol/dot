local lsp = vim.lsp

lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'h', 'hpp', 'cc' },
  root_markers = { '.git' },
}
lsp.enable('clangd')

lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', '.git' },
}
lsp.enable('gopls')

lsp.semantic_tokens.enabled = false
