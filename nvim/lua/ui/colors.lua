vim.cmd([[
colorscheme quiet
]])

-- Highlight helper
local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- Refined monochromatic palette
local colors = {
  bg        = "#000000",
  bgAlt     = "#0a0a0a",
  fg        = "#d0d0d0",      -- Softer white for less eye strain
  fgDim     = "#808080",

  cursor    = "#00ff00",
  cursorLine= "#1a1a1a",      -- Subtle, not red-tinted
  lineNr    = "#404040",
  visual    = "#2a2a2a",      -- Neutral gray selection

  accent    = "#c0a0a0",      -- Warm neutral for keywords/functions
  bright    = "#a0a0a0",      -- Medium gray
  medium    = "#707070",      -- Dim gray
  dim       = "#505050",      -- Dimmer
  comment   = "#404040",      -- Very subtle
}

-- Editor UI
hl("Normal",        { fg = colors.fg, bg = colors.bg })
hl("CursorLine",    { bg = colors.cursorLine })
hl("CursorLineNr",  { fg = colors.accent })
hl("LineNr",        { fg = colors.lineNr })
hl("Visual",        { bg = colors.visual })
hl("MatchParen",    { fg = colors.accent, bold = true })

hl("StatusLine",    { fg = colors.fg, bg = "NONE" })
hl("WinBar",        { bg = "NONE", fg = colors.bright })
hl("StatusLineNC",  { fg = colors.medium, bg = "NONE" })

-- Functions - single accent color
hl("@function",              { fg = colors.accent })
hl("@function.call",         { fg = colors.fg })
hl("@function.builtin",      { fg = colors.bright })
hl("@function.method",       { fg = colors.accent })
hl("@function.method.call",  { fg = colors.fg })

-- Variables - understated
hl("@parameter",             { fg = colors.fg })
hl("@variable.parameter",    { fg = colors.fg })
hl("@variable",              { fg = colors.fg })
hl("@variable.builtin",      { fg = colors.bright })
hl("@variable.member",       { fg = colors.fg })
hl("@property",              { fg = colors.fg })
hl("@field",                 { fg = colors.fg })

-- Punctuation - very subtle
hl("@punctuation.bracket",   { fg = colors.dim })
hl("@punctuation.delimiter", { fg = colors.dim })
hl("@punctuation.special",   { fg = colors.medium })
hl("Delimiter",              { fg = colors.dim })
hl("@operator",              { fg = colors.medium })

-- Keywords - accent for visibility
hl("@keyword",               { fg = colors.accent })
hl("@keyword.function",      { fg = colors.accent })
hl("@keyword.return",        { fg = colors.accent })
hl("@keyword.operator",      { fg = colors.bright })

-- Types
hl("@type",                  { fg = colors.bright })
hl("@type.builtin",          { fg = colors.bright })

-- Constants - slightly brighter
hl("@constant",              { fg = colors.bright })
hl("@constant.builtin",      { fg = colors.bright })
hl("@constant.macro",        { fg = colors.accent })

-- Strings - medium gray
hl("@string",                { fg = colors.medium })
hl("@string.escape",         { fg = colors.bright })
hl("@character",             { fg = colors.medium })
hl("@string.special",        { fg = colors.medium })
hl("@string.special.path",   { fg = colors.medium })

-- Legacy + LSP
hl("String",                 { fg = colors.medium })
hl("Character",              { fg = colors.medium })
hl("@lsp.type.string",       { link = "@string" })

-- Preprocessor
hl("PreProc",                { fg = colors.accent })
hl("@keyword.directive",     { fg = colors.accent })
hl("Include",                { fg = colors.bright })
hl("@include",               { fg = colors.bright })

-- Numbers
hl("@number",                { fg = colors.bright })
hl("@float",                 { fg = colors.bright })
hl("@boolean",               { fg = colors.bright })

-- Comments - very subtle
hl("@comment",               { fg = colors.comment, italic = true })
hl("@comment.documentation", { fg = colors.dim })

-- Misc
hl("@attribute",             { fg = colors.bright })
hl("@constructor",           { fg = colors.bright })
hl("@namespace",             { fg = colors.bright })
hl("@module",                { fg = colors.bright })

hl("@tag",                   { fg = colors.accent })
hl("@tag.attribute",         { fg = colors.medium })
hl("@tag.delimiter",         { fg = colors.dim })
 -- Tabline colors
hl("TabLine",      { fg = colors.accent, bg = colors.bg })      -- Inactive tabs
hl("TabLineSel",   { fg = colors.bg, bg = colors.accent })      -- Active tab (inverted)
hl("TabLineFill",  { fg = colors.fg, bg = colors.bg })          -- Empty space

-- Cursor
hl("Cursor",   { fg = colors.bg, bg = colors.cursor })
hl("iCursor",  { fg = colors.bg, bg = colors.accent })
hl("rCursor",  { fg = colors.bg, bg = colors.medium })

-- Floating window colors
hl("NormalFloat",   { fg = colors.accent, bg = colors.bg })  -- Bright text on black
hl("FloatBorder",   { fg = colors.accent, bg = colors.bg })  -- Matching border
hl("FloatTitle",    { fg = colors.accent, bg = colors.bg, bold = true })

-- LSP-specific floating windows
hl("LspInfoBorder", { fg = colors.accent, bg = colors.bg })

-- Noice floating windows (if you're using it)
hl("NoiceCmdlinePopup",      { fg = colors.accent, bg = colors.bg })
hl("NoiceCmdlinePopupBorder", { fg = colors.accent, bg = colors.bg })
hl("NoicePopupBorder",       { fg = colors.accent, bg = colors.bg })
hl("NoiceConfirmBorder",     { fg = colors.accent, bg = colors.bg })

 -- Completion menu (Pmenu)
hl("Pmenu",      { fg = colors.accent, bg = colors.bg })       -- Main completion window
hl("PmenuSel",   { fg = colors.bg, bg = colors.accent })       -- Selected item (inverted)
hl("PmenuSbar",  { bg = colors.dim })                          -- Scrollbar background
hl("PmenuThumb", { bg = colors.accent })                       -- Scrollbar thumb

-- Completion item kinds (optional - makes icons/labels pop)
hl("CmpItemKind",          { fg = colors.accent })
hl("CmpItemMenu",          { fg = colors.medium })
hl("CmpItemAbbr",          { fg = colors.fg })
hl("CmpItemAbbrMatch",     { fg = colors.accent, bold = true }) -- Matched characters
hl("CmpItemAbbrMatchFuzzy", { fg = colors.accent })

vim.opt.guicursor = {
  "n-v-c:block-Cursor",
  "i:block-iCursor",
  "r:block-rCursor",
}

-- Autocmds
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    hl("Cursor",  { fg = colors.bg, bg = colors.accent })
    hl("iCursor", { fg = colors.bg, bg = colors.accent })
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

