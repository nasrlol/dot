vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'h', 'hpp', 'cc'},
  root_markers = { '.git' },
}

hl('@lsp.type.variable', {})
hl('@lsp.type.function', {})
hl('@lsp.type.keyword', {})
hl('@lsp.type.comment', {})
hl('@lsp.type.string', {})
hl('@lsp.type.number', {})
hl('@lsp.type.operator', {})
hl('@lsp.type.punctuation', {})

vim.lsp.enable('clangd')
vim.lsp.semantic_tokens.enabled = false
