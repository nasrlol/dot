return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  config = function()
    require("fzf-lua").setup({
      winopts = {
        preview = {
          hidden = "hidden",
        },
      },
    })
  end,
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fa", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    { "<leader>ra", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace diagnostics" },
    { "<leader>rf", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document diagnostics" },
    { "<leader>un", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
    { "<leader>cs", "<cmd>FzfLua colorschemes<cr>", desc = "Colorschemes" },
    { "<leader>man", "<cmd>FzfLua manpages<cr>", desc = "Man pages" },
  },
}
