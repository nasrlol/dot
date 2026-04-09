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
        formatter = "path.filename_first",
        fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude .cache --exclude tags --exclude TAGS",
        winopts = inline,
        prompt = "files :: ",
        hidden =  true,
        cwd_prompt  = false,
    },

    buffers = {
        ignore_current_buffer = true,
        sort_mru = true,
    },

    grep = {
        prompt      = "found ::  ", 
        input_prompt = "grep ::  ",
        lgrep        = true,
        rg_opts      = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        winopts      = inline,
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
