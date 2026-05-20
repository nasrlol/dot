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
lsp.config['rust-analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
}
lsp.enable('rust-analyzer')
lsp.semantic_tokens.enabled = false
