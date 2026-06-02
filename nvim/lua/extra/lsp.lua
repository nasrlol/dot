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

lsp.config('asm_lsp', {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm', 's', 'S' },
    root_markers = { '.asm-lsp.toml', '.git' },
})

-- Enable it globally
vim.lsp.enable('asm_lsp')

lsp.enable('rust-analyzer')
lsp.semantic_tokens.enabled = false
