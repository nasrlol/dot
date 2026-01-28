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
  end
}
