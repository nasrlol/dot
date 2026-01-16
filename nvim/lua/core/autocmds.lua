vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 then
      vim.cmd("normal! g`\"")
    end
  end,
})

local function get_root()
  local root = vim.fs.find({
    "compile_commands.json",
    ".git",
    "Makefile",
    "CMakeLists.txt",
  }, { upward = true })[1]

  return root and vim.fs.dirname(root) or nil
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    local root = get_root()
    if not root then return end

    vim.lsp.start({
      name = "clangd",
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
      },
      root_dir = root,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = require("lsp.on_attach"),
    })
  end,
})
