local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

-- jump to previous cursor position
autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lc = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lc then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

autocmd("LspAttach", {
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
})

autocmd('LspAttach', {
  callback = function(args)
    local client_id = args.data.client_id
    local bufnr = args.buf

    vim.lsp.completion.enable(true, client_id, bufnr)
  end,
})

autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
