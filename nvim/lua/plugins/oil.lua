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
      -- "permissions", -- Often causes issues, consider removing if problematic
      -- "size",
      -- "mtime",
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
      relativenumber = false, -- Changed from true - often causes issues in oil buffers
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
      autosave_changes = false, -- Changed from true - can cause issues with LSP
    },
    delete_to_trash = true,
    trash_command = "gio trash", -- Use trash_command instead of trash.cmd
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
    -- Git integration - simplified
    git = {
      add = function(path)
        return true -- Let oil handle it automatically
      end,
      mv = function(src_path, dest_path)
        return true -- Let oil handle it automatically
      end,
      rm = function(path)
        return true -- Let oil handle it automatically
      end,
    },
    watch_for_changes = true,
    -- Add keymaps for common operations
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
  -- Add dependencies
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}
