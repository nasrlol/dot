local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    height = 0.85,
    width = 0.85,
  }}
)

-- Key mappings (customize these as needed)
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fa", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ra", fzf.diagnostics_workspace, { desc = "workspace diagnostics" })
vim.keymap.set("n", "<leader>rf", fzf.diagnostics_document, { desc = "current document diagnosticd" })
vim.keymap.set("n", "<leader>un", fzf.undotree, { desc = "undo tree" })
vim.keymap.set("n", "<leader>cs", fzf.colorschemes, { desc = "colorschemes" })
vim.keymap.set("n", "<leader>man", fzf.manpages, { desc = "man pages" })

