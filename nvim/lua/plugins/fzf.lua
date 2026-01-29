return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  config = function()
    require("fzf-lua").setup({
      winopts = {
        width = 0.5,
        height = 0.5,
        preview = {
          hidden = "hidden",
        },
      },
    })
  end
}
