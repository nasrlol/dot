 return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "GMove", "GDelete", "GBrowse" },
    keys = {
        { "<leader>gs", "<cmd>Git<cr>",                    desc = "Git status" },
        { "<leader>gd", "<cmd>Gdiffsplit<cr>",             desc = "Git diff split" },
        { "<leader>gb", "<cmd>Git blame<cr>",              desc = "Git blame" },
        { "<leader>gl", "<cmd>Git log --oneline<cr>",      desc = "Git log" },
        { "<leader>gp", "<cmd>Git push<cr>",               desc = "Git push" },
        { "<leader>gP", "<cmd>Git pull<cr>",               desc = "Git pull" },
        { "<leader>gc", "<cmd>Git commit<cr>",             desc = "Git commit" },
        { "<leader>gw", "<cmd>Gwrite<cr>",                 desc = "Git stage file" },
        { "<leader>gr", "<cmd>Gread<cr>",                  desc = "Git checkout file" },
        { "<leader>gm", "<cmd>GMove<cr>",                  desc = "Git move/rename" },
        { "<leader>gD", "<cmd>GDelete<cr>",                desc = "Git delete" },
    },
}
