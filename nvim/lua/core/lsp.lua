local lsp = vim.lsp

-- ------------------------------------------------------------
-- Capabilities
-- ------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

-- ------------------------------------------------------------
-- Disable Semantic Tokens (Safe Method)
-- ------------------------------------------------------------
vim.lsp.handlers["textDocument/semanticTokens/full"] = function() end
vim.lsp.handlers["textDocument/semanticTokens/range"] = function() end

-- ------------------------------------------------------------
-- clangd (C / C++)
-- ------------------------------------------------------------
lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--pch-storage=memory",
    "-j=4",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cc", "h", "hpp" },
  root_markers = { "Makefile", "compile_commands.json", ".git" },
  capabilities = capabilities,
}

-- ------------------------------------------------------------
-- rust-analyzer
-- ------------------------------------------------------------
lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      semanticHighlighting = false,
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      cargo = {
        buildScripts = { enable = false },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

-- ------------------------------------------------------------
-- gopls
-- ------------------------------------------------------------
lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
  settings = {
    gopls = {
      semanticTokens = false,
      analyses = {
        unusedparams = true,
        shadow = false,
      },
      staticcheck = false,
      gofumpt = true,
    },
  },
}

-- ------------------------------------------------------------
-- Lua LS (Neovim config editing)
-- ------------------------------------------------------------
lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git" },
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
        disable = { "lowercase-global" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
        maxPreload = 2000,
        preloadFileSize = 50000,
      },
      telemetry = { enable = false },
      hint = { enable = false },
    },
  },
}

-- ------------------------------------------------------------
-- Diagnostics
-- ------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Custom diagnostic signs
local signs = {
  Error = "󰅚 ",
  Warn  = "󰀪 ",
  Hint  = "󰌶 ",
  Info  = "󰋼 ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ------------------------------------------------------------
-- Hover & Signature Border
-- ------------------------------------------------------------
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- ------------------------------------------------------------
-- LspAttach (format on save)
-- ------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    -- Format on save (if supported)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        group = vim.api.nvim_create_augroup("LspFormat", { clear = false }),
        callback = function()
          vim.lsp.buf.format({
            bufnr = ev.buf,
            id = client.id,
            timeout_ms = 1000,
          })
        end,
      })
    end
  end,
})

-- ------------------------------------------------------------
-- Enable Servers
-- ------------------------------------------------------------
lsp.enable("clangd")
lsp.enable("rust_analyzer")
lsp.enable("gopls")
lsp.enable("lua_ls")

