return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      "permissions", 
      "size",
      "mtime",
    },
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, _)
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, _)
        return name == ".git" or name == "node_modules"
      end,
      natural_order = true,
      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },
    },
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      number = false,
      relativenumber = false, 
      list = false,
      conceallevel = 1,
      concealcursor = "nvic",
    },
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    delete_to_trash = true,
    trash_command = "gio trash",
    use_default_keymaps = true,
    preview = {
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 40,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    git = {
      add = function(path)
        return true 
      end,
      mv = function(src_path, dest_path)
        return true 
      end,
      rm = function(path)
        return true 
      end,
    },
    watch_for_changes = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  },
}
