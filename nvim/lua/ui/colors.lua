vim.cmd([[
colorscheme sorbet
]])

-- Highlight helper
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- Monochromatic palette
local colors = {
  bg        = "#000000",
  bgAlt     = "#0a0a0a",
  fg        = "#ffffff",
  fgDim     = "#808080",

  cursor    = "#00ff00",
  cursorLine= "#440000",
  lineNr    = "#404040",
  visual    = "#0f4400",

  brightest = "#ff444f",
  bright    = "#dfd0d0",
  medium    = "#a0a0a0",
  dim       = "#707070",
  dimmer    = "#505050",
  comment   = "#444499",
}

-- Editor UI
hl("Normal",        { fg = colors.fg, bg = colors.bg })
hl("CursorLine",    { bg = colors.cursorLine })
hl("CursorLineNr",  { fg = colors.brightest })
hl("LineNr",        { fg = colors.lineNr })
hl("Visual",        { bg = colors.visual })
hl("MatchParen",    { fg = colors.brightest, underline = true })

hl("StatusLine",    { fg = colors.fg,    bg = "NONE" })
hl("WinBar",        { bg = "NONE", fg = "#a9b1d6" })
hl("StatusLineNC",  { fg = colors.fg, bg = "NONE" })

-- Functions
hl("@function",              { fg = colors.brightest })
hl("@function.call",         { fg = colors.bright })
hl("@function.builtin",      { fg = colors.bright })
hl("@function.method",       { fg = colors.brightest })
hl("@function.method.call",  { fg = colors.bright })

-- Parameters / Variables
hl("@parameter",             { fg = colors.medium })
hl("@variable.parameter",    { fg = colors.medium })

hl("@variable",              { fg = colors.medium })
hl("@variable.builtin",      { fg = colors.bright })
hl("@variable.member",       { fg = colors.medium })
hl("@property",              { fg = colors.medium })
hl("@field",                 { fg = colors.medium })

-- Punctuation / Operators
hl("@punctuation.bracket",   { fg = colors.dim })
hl("@punctuation.delimiter", { fg = colors.dim })
hl("@punctuation.special",   { fg = colors.medium })
hl("Delimiter",              { fg = colors.dim })

hl("@operator",              { fg = colors.dim })

-- Keywords / Types
hl("@keyword",               { fg = colors.brightest })
hl("@keyword.function",      { fg = colors.brightest })
hl("@keyword.return",        { fg = colors.brightest })
hl("@keyword.operator",      { fg = colors.bright })

hl("@type",                  { fg = colors.bright })
hl("@type.builtin",          { fg = colors.bright })

hl("@constant",              { fg = colors.brightest })
hl("@constant.builtin",      { fg = colors.brightest })
hl("@constant.macro",        { fg = colors.brightest })

-- Strings (neutral, fixed)
hl("@string",                { fg = colors.medium })
hl("@string.escape",         { fg = colors.bright })
hl("@character",             { fg = colors.medium })
hl("@string.special",        { fg = colors.medium })
hl("@string.special.path",   { fg = colors.medium })

-- Legacy + LSP safety
hl("String",                 { fg = colors.medium })
hl("Character",              { fg = colors.medium })
hl("@lsp.type.string",       { link = "@string" })

-- Preprocessor / Includes
hl("PreProc",                { fg = colors.brightest })
hl("@keyword.directive",     { fg = colors.brightest })
hl("Include",                { fg = colors.bright })
hl("@include",               { fg = colors.bright })

-- Numbers / Booleans
hl("@number",                { fg = colors.bright })
hl("@float",                 { fg = colors.bright })
hl("@boolean",               { fg = colors.bright })

-- Comments
hl("@comment",               { fg = colors.comment })
hl("@comment.documentation", { fg = colors.dimmer })

-- Misc
hl("@attribute",             { fg = colors.bright })
hl("@constructor",           { fg = colors.bright })
hl("@namespace",             { fg = colors.bright })
hl("@module",                { fg = colors.bright })

hl("@tag",                   { fg = colors.bright })
hl("@tag.attribute",         { fg = colors.medium })
hl("@tag.delimiter",         { fg = colors.dim })

-- Cursor
hl("Cursor",   { fg = colors.bg, bg = "#904344" })
hl("iCursor",  { fg = colors.bg, bg = colors.brightest })
hl("rCursor",  { fg = colors.bg, bg = colors.medium })

hl("NoiceCmdlinePopupBorder", { fg = "#666666" })
hl("NoicePopupBorder",       { fg = "#666666" })
hl("NoiceConfirmBorder",     { fg = "#666666" })

vim.opt.guicursor = {
  "n-v-c:block-Cursor",
  "i:block-iCursor",
  "r:block-rCursor",
}


-- Autocmds
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    hl("Cursor",  { fg = colors.bg, bg = colors.brightest })
    hl("iCursor", { fg = colors.bg, bg = colors.brightest })
    hl("rCursor", { fg = colors.bg, bg = colors.medium })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
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
