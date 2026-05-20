local fzf = require("fzf-lua")
fzf.setup({
    multiprocess = true,
    fzf_opts = {
        ["--layout"] = "reverse",
        ["--sync"] = "",
        ["--no-scrollbar"] = "",
        ["--info"] = "hidden",
        ["--keep-right"] = "",
    },



files = {
    formatter = "path.filename_first",
    fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude .cache --exclude tags --exclude TAGS --exclude Cargo.lock --exclude target --exclude .venv --exclude dist --exclude build",
    prompt = " files :: ",
    hidden = true,
    cwd_prompt = false,
    winopts = {
        preview = { hidden = "always" }
    }
},


    buffers = {
        ignore_current_buffer = true,
        sort_mru = true,
    },
    grep = {
        prompt = " found :: ",
        input_prompt = " grep :: ",
        lgrep = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    },
    ui_select = {
        winopts = {
            relative = "cursor",
            height = 0.4,
            width = 0.6,
        },
    },
})
