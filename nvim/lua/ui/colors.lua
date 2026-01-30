vim.cmd([[
colorscheme habamax
set termguicolors
syntax on
filetype plugin indent on
]])

-- Highlight helper
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- Color palette
local colors = {
  cursor       = "#f00f5f",
  bg           = "#0f1115",
  fg           = "#d4d4d4",
  comment      = "#505050",
  cursorLineNr = "#00ff00",
  visual       = "#1c4b06",
  cyan         = "#00a8a8",
  blue         = "#0088ff",
  purple       = "#c040c0",
  pink         = "#f92672",
  green        = "#50ff30",
  yellow       = "#f0c674",
  orange       = "#ff9e64",
  red          = "#ff2040",
  white        = "#ffffff",
}

-- Editor UI
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("CursorLine", { bg = colors.comment })
hl("CursorLineNr", { fg = colors.cursorLineNr, bold = true })
hl("LineNr", { fg = colors.comment })
hl("Visual", { fg = colors.bg, bg = colors.cursor, bold = true })
hl("VisualNOS", { fg = colors.fg, bg = colors.visual })
hl("@function", { fg = colors.blue, bold = false})
hl("@function.call", { fg = colors.blue, bold = false})

-- Cursor highlights for different modes
hl("Cursor", {
  fg = "#000000",
  bg = "#f00f5f",
})

hl("iCursor", {
  fg = "#000000",
  bg = "#f00f5f",
})

hl("rCursor", {
  fg = "#000000",
  bg = "#ff5f5f",
})

-- Cursor shape configuration
vim.opt.guicursor = {
  "n-v-c:block-Cursor",
  "i:block-iCursor",
  "r:block-rCursor",
}

-- Autocmd to restore cursor highlights after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", {
      fg = "#000000",
      bg = "#44ff44",

    })
    vim.api.nvim_set_hl(0, "iCursor", {
      fg = "#ffffff",
      bg = "#f00f5f",
    })
    vim.api.nvim_set_hl(0, "rCursor", {
      fg = "#000000",
      bg = "#ff5f5f",
    })
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Equalize splits on resize
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 then
      vim.cmd("normal! g`\"")
    end
  end,
})
