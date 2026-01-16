local on_attach = require("lsp.on_attach")

vim.lsp.start({
  name = "clangd",
  cmd = { "clangd", "--background-index" },
  root_dir = vim.fs.dirname(
    vim.fs.find(
      { "compile_commands.json", ".git", "Makefile", "CMakeLists.txt" },
      { upward = true }
    )[1]
  ),
  on_attach = on_attach,
})
