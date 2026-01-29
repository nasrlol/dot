return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require'nvim-treesitter.configs'.setup{
      ensure_installed = { "lua", "c", "cpp", "rust", "lua" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
