vim.cmd([[
colorscheme quiet
set termguicolors
syntax on
filetype plugin indent on
]])

-- Highlight helper
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- Functional color palette - bright where it matters, muted elsewhere
local colors = {
  -- UI Base
  bg           = "#000000",
  bgAlt        = "#1a1a1a",
  fg           = "#c0c0c0",
  fgDim        = "#606060",

  -- Editor
  cursor       = "#00ff00",
  cursorLine   = "#1a1a1a",
  lineNr       = "#404040",
  visual       = "#2a3a4a",

  -- Bright functional colors
  function_def = "#00bbff",      -- Clear function definitions
  function_call= "#f44550",      -- Calls stand out
  keyword      = "#ff8800",      -- Keywords are obvious
  type         = "#00dddd",      -- Types clear
  string       = "#00ff00",      -- Strings bright green
  number       = "#ffaa00",      -- Numbers visible
  error        = "#ff0000",      -- Errors scream

  -- Muted structural
  comment      = "#505050",      -- Comments fade back
  punctuation  = "#707070",
  variable     = "#b0b0b0",      -- Variables neutral

  -- Semantic
  macro        = "#ff44ff",
  constant     = "#ff9900",
  builtin      = "#00aaaa",
}

-- Editor UI - minimal distraction
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("CursorLine", { bg = colors.cursorLine })
hl("CursorLineNr", { fg = colors.cursor, bold = true })
hl("LineNr", { fg = colors.lineNr })
hl("Visual", { bg = colors.visual })
hl("MatchParen", { fg = colors.cursor, bold = true })

-- Functions - most important, brightest
hl("@function", { fg = colors.function_def, bold = true })
hl("@function.call", { fg = colors.function_call, bold = true })
hl("@function.builtin", { fg = colors.builtin })
hl("@function.method", { fg = colors.function_def, bold = true })
hl("@function.method.call", { fg = colors.function_call, bold = true })

-- Parameters - visible but not distracting
hl("@parameter", { fg = colors.variable })
hl("@variable.parameter", { fg = colors.variable })

-- Punctuation - quiet, structural
hl("@punctuation.bracket", { fg = colors.punctuation })
hl("@punctuation.delimiter", { fg = colors.punctuation })
hl("@punctuation.special", { fg = colors.punctuation })
hl("Delimiter", { fg = colors.punctuation })

-- Variables - neutral
hl("@variable", { fg = colors.variable })
hl("@variable.builtin", { fg = colors.builtin })
hl("@variable.member", { fg = colors.variable })
hl("@property", { fg = colors.variable })
hl("@field", { fg = colors.variable })

-- Keywords - bright orange, stand out
hl("@keyword", { fg = colors.keyword, bold = true })
hl("@keyword.function", { fg = colors.keyword, bold = true })
hl("@keyword.return", { fg = colors.keyword, bold = true })
hl("@keyword.operator", { fg = colors.keyword })
hl("@operator", { fg = colors.punctuation })

-- Types - cyan, clear
hl("@type", { fg = colors.type, bold = true })
hl("@type.builtin", { fg = colors.type, bold = true })
hl("@constant", { fg = colors.constant, bold = true })
hl("@constant.builtin", { fg = colors.constant, bold = true })
hl("@constant.macro", { fg = colors.macro, bold = true })

-- Strings - bright green
hl("@string", { fg = colors.string })
hl("@string.escape", { fg = colors.number })
hl("@character", { fg = colors.string })

-- Numbers - bright orange/yellow
hl("@number", { fg = colors.number, bold = true })
hl("@float", { fg = colors.number, bold = true })
hl("@boolean", { fg = colors.number, bold = true })

-- Comments - fade into background
hl("@comment", { fg = colors.comment, italic = true })
hl("@comment.documentation", { fg = colors.comment, italic = true })

-- Attributes
hl("@attribute", { fg = colors.macro })

-- Constructors and Modules
hl("@constructor", { fg = colors.type, bold = true })
hl("@namespace", { fg = colors.type })
hl("@module", { fg = colors.type })

-- Tags
hl("@tag", { fg = colors.keyword })
hl("@tag.attribute", { fg = colors.variable })
hl("@tag.delimiter", { fg = colors.punctuation })

-- Cursor modes - bright and visible
hl("Cursor", { fg = colors.bg, bg = colors.cursor })
hl("iCursor", { fg = colors.bg, bg = colors.cursor })
hl("rCursor", { fg = colors.bg, bg = colors.error })

vim.opt.guicursor = {
  "n-v-c:block-Cursor",
  "i:block-iCursor",
  "r:block-rCursor",
}

-- Autocmds
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    hl("Cursor", { fg = colors.bg, bg = colors.cursor })
    hl("iCursor", { fg = colors.bg, bg = colors.cursor })
    hl("rCursor", { fg = colors.bg, bg = colors.error })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 then
      vim.cmd("normal! g`\"")
    end
  end,
})
