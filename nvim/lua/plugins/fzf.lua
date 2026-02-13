 return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  config = function()
    local fzf = require("fzf-lua")
    
    fzf.setup({
      winopts = {
        height = 0.50, 
        width  = 0.80, 
        row    = 0.35,
        col    = 0.50,
        border = "rounded", 
        preview = {
          hidden       = "hidden",  
          layout       = "vertical",
          vertical     = "up:60%",  
          scrollbar    = "float",
          keymap = {
            toggle_preview = "<C-_>",
          },
        },
      },

      fzf_opts = {
        ["--ansi"]   = "",
        ["--info"]   = "inline", 
        ["--layout"] = "reverse", 
      },

      files = {
        formatter = "path.filename_first", 
        git_icons = false,
        file_icons = false,
      },

      buffers = {
        show_unloaded = true,
        show_all_buffers = true,
        winopts = { height = 0.3, width = 0.6 },
      },

      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept", 
        },
      },
    })
  end,
}
