vim.api.nvim_create_user_command("Oil", function()
  require("oil").open()
end, {})

-- setup
require("oil").setup({
  default_file_explorer = true,
  columns = {
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    show_hidden = true,
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
    enabled = false,
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
    padding = 0,
    max_width = 80,
    max_height = 40,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  git = {
    add = function(_) return true end,
    mv = function(_, _) return true end,
    rm = function(_) return true end,
  },
  watch_for_changes = true,
})
