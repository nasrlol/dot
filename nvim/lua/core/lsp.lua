-- Enhanced client capabilities (completion metadata only, no UI)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

local lsp = vim.lsp

-- clangd configuration
lsp.config.clangd = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--offset-encoding=utf-16",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cc", "h", "hpp" },
    root_markers = { "Makefile", { "build.sh", ".git" } },
    capabilities = capabilities,
}

lsp.config.bufls = {
    cmd = { "bufls", "serve" },
    filetypes = { "proto" },
    root_markers = { "buf.yaml", ".git" },
}

lsp.config.neocmake = {
    cmd = { "neocmakelsp", "--stdio" },
    filetypes = { "cmake", "make" },
    root_markers = { "CMakeLists.txt", "Makefile", ".git" },
}

lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
}

lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork" },
    root_markers = { "go.work", "go.mod", ".git" },
}


-- LSP attach logic
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end
    end,
})

-- Enable lsps
lsp.enable("clangd")
lsp.enable("bufls")
lsp.enable("neocmake")
lsp.enable("rust_analyzer")
lsp.enable("gopls")
