-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Find project root directory
local function get_root()
  local root = vim.fs.find(
    { ".git", "compile_commands.json", "build.sh" },
    { upward = true }
  )[1]
  return root and vim.fs.dirname(root) or nil
end

-- Clangd LSP setup
local group = vim.api.nvim_create_augroup("ClangdLSP", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(args)
    -- Avoid starting clangd twice for the same buffer
    for _, client in pairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if client.name == "clangd" then
        return
      end
    end

    local root = get_root()
    if not root then
      return
    end

    vim.lsp.start({
      name = "clangd",
      root_dir = root,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--index-file=" .. root .. "/project.idx",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
      },
    })
  end,
})

vim.api.nvim_create_user_command("Z", function(opts)
  local query = table.concat(opts.fargs, " ")
  local handle = io.popen("zoxide query " .. vim.fn.shellescape(query))
  if not handle then return end

  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  if result ~= "" then
    vim.cmd.cd(result)
  else
    vim.notify("zoxide: no match", vim.log.levels.WARN)
  end
end, {
  nargs = "*",
  complete = function(_, line)
    return vim.fn.systemlist("zoxide query -l")
  end,
})
