local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.stop, ev.buf, "highlight")
    end,
})
