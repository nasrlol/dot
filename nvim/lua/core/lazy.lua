-- ============================================================================
-- lazy.nvim bootstrap
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- lazy.nvim setup
-- ============================================================================

require("lazy").setup({

  -- --------------------------------------------------------------------------
  -- fzf-lua (lazy: on command / key)
  -- --------------------------------------------------------------------------
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>f", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>g", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    },
  },

  -- --------------------------------------------------------------------------
  -- oil.nvim (lazy: file explorer)
  -- --------------------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {}, -- safe: opts are applied when plugin loads
  },

  -- --------------------------------------------------------------------------
  -- nvim-cmp (lazy: InsertEnter)
  -- --------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-buffer",   lazy = true },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
    end,
  },

}, {
  defaults = {
    lazy = true,
  },
  install = {
    missing = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
