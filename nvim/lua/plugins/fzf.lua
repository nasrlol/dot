return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = function()
        local fzf = require("fzf-lua")
        local inline = {
            split = "belowright 15new",
            width = 1.0,
            row = 1.0,
            border = "none",
            preview = { hidden = true },
        }
        fzf.setup({
            multiprocess = true,

            fzf_opts = {
                ["--layout"] = "reverse",
                ["--sync"] = "",
                ["--no-scrollbar"] = "",
                ["--info"] = "hidden",
                ["--keep-right"] = "",
            },

            winopts = inline,

            files = {
                cwd_prompt = false,
                formatter = "path.filename_first",
                fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude .cache --exclude tags --exclude TAGS",
            },

            buffers = {
                ignore_current_buffer = true,
                sort_mru = true,
            },

            grep = {
                winopts = inline,
            },

            lsp = {
                winopts = inline,
            },

            commands = {
                winopts = inline,
            },

            ui_select = {
                winopts = {
                    relative = "cursor",
                    height = 0.4,
                    width = 0.6,
                },
            },
        })
    end,
}
