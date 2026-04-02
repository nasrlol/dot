 return {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    config = function()
        require("marks").setup({
            default_mappings = false,
            signs = true,
            refresh_interval = 250,
            sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
            mappings = {
                set            = "m",
                set_next       = "m,",
                next           = "']",
                prev           = "'[",
                delete         = "dm",
                delete_line    = "dm-",
                delete_buf     = "dm<Space>",
                preview        = "m;",
            },
        })
    end,
}
