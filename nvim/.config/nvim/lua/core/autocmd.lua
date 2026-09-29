local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

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

