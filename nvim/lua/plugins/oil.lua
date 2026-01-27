return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    columns = {
      "icon",
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
      relativenumber = true,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
    delete_to_trash = true,
    trash = {
      cmd = "gio trash",
    },
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
        return vim.fn.system({ "git", "add", path })
      end,
      mv = function(src, dest)
        return vim.fn.system({ "git", "mv", src, dest })
      end,
      rm = function(path)
        return vim.fn.system({ "git", "rm", path })
      end,
    },
    watch_for_changes = true,
  },
}
