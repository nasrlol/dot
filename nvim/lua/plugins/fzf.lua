 return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      nbsp = " ", 
      multiprocess = false,

      winopts = {
        split = "belowright 15new", 
        width = 1.0,                
        row = 1.0,                  
        border = "none",            
        
        on_create = function()
          vim.opt_local.termguicolors = true
        end,

        preview = {
          hidden = true,
          layout = "vertical",
          vertical = "down:50%",
          scrollbar = "float",
        },                 
      },

      fzf_opts = {
        ["--ansi"] = "",
        ["--info"] = "inline",
        ["--layout"] = "reverse",
        ["--no-unicode"] = "", 
      },

      -- Crucial: Ensure the global keymap doesn't conflict
      keymap = {
        builtin = {
          -- If <C-p> still fails, try mapping it here as well:
          ["<C-p>"]     = "toggle-preview",
          ["<C-d>"]     = "preview-page-down",
          ["<C-u>"]     = "preview-page-up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
          -- This ensures the fzf binary itself doesn't steal the key
          ["ctrl-p"] = "toggle-preview",
        },
      },

      files = {
        formatter = "path.filename_first",
        git_icons = false,
        file_icons = false,
        color_icons = false, 
      },
    })
    
    fzf.register_ui_select()
  end,
}







