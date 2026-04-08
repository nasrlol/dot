vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e"
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
    callback = function()
        if vim.fn.pumvisible() == 1 then return end
        local line = vim.api.nvim_get_current_line()
        local col  = vim.api.nvim_win_get_cursor(0)[2]
        local before = line:sub(1, col)
        -- only trigger after 2+ word chars
        if before:match("[%w_][%w_]+$") then
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-x><C-n>", true, false, true),
                "i", true
            )
        end
    end,
})
