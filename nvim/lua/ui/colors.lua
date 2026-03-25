local function hl(name, opts)
    opts.force = true
    vim.api.nvim_set_hl(0, name, opts)
end

local colors = {
    bg         = "#072626", 
    bgAlt      = "#262626", 
    fg         = "#A08563", 
    fgDim      = "#5B4D3C", 
    cursor     = "#FF4040", 
    cursorAlt  = "#FF4040",
    cursorLine = NONE, 
    lineNr     = "#505050", 
    lineNrBg   = "#202020",
    visual     = "#703419", 
    search     = "#703419", 
    border     = "#262626",
    comment    = "#7D7D7D", 
    commentPop = "#00A000",
    keyword    = "#CD950C", 
    string     = "#6B8E23", 
    constant   = "#6B8E23",
    type       = "#A08563", 
    accent     = "#CDAA7D",
    preproc    = "#DAB98F",
    bar        = "#CACACA",
    barActive  = "#A8A8A8",
    pop1       = "#03CF0C",
    pop2       = "#FF0000",
}

if  vim.g.neovide then
    hl("Normal", { fg = colors.fg, bg = colors.bg })
    hl("NormalFloat",  { fg = colors.fg, bg = colors.bgAlt })
else 
    hl("Normal", { fg = colors.fg, bg = "NONE" })
    hl("NormalFloat",  { fg = colors.fg, bg = "NONE" })
end

hl("FloatBorder",  { fg = colors.border, bg = colors.bgAlt })

hl("Cursor",       { fg = colors.bg, bg = colors.cursor })
hl("TermCursor",   { fg = colors.bg, bg = colors.cursor })

hl("CursorLine",   { bg = colors.cursorLine })
hl("CursorLineNr", { fg = colors.accent, bold = true, bg = colors.cursorLine })
hl("LineNr",       { fg = colors.lineNr, bg = None })

hl("Visual",       { fg = colors.fg, bg = colors.visual })
hl("MatchParen",   { fg = colors.bg, bg = colors.accent, bold = true })

hl("Search",       { bg = colors.search })
hl("IncSearch",    { fg = colors.bg, bg = colors.cursor })

hl("StatusLine",   { fg = colors.fg, bg = colors.bgAlt })
hl("StatusLineNC", { fg = colors.fgDim, bg = colors.bg })

hl("VertSplit",    { fg = colors.border, bg = "NONE" })
hl("WinSeparator", { fg = colors.border, bg = "NONE" })
hl("WinBar",       { fg = colors.bar, bg = "NONE", bold = true })

hl("Pmenu",        { fg = colors.fg, bg = colors.bgAlt })
hl("PmenuSel",     { fg = colors.bg, bg = colors.accent, bold = false })
hl("PmenuSbar",    { bg = colors.bgAlt })
hl("PmenuThumb",   { bg = colors.bar })

-- Syntax Highlighting
hl("Comment",      { fg = colors.comment, italic = false })
hl("Constant",     { fg = colors.constant })
hl("String",       { fg = colors.string })
hl("Character",    { fg = colors.string })
hl("Number",       { fg = colors.constant })
hl("Boolean",      { fg = colors.constant, bold = true })
hl("Float",        { fg = colors.constant })

hl("Identifier",   { fg = colors.fg })
hl("Function",     { fg = colors.fg, bold = true })

hl("Statement",    { fg = colors.keyword, bold = true })
hl("Conditional",  { fg = colors.keyword, bold = true })
hl("Repeat",       { fg = colors.keyword, bold = true })
hl("Label",        { fg = colors.keyword })
hl("Operator",     { fg = colors.fg })
hl("Keyword",      { fg = colors.keyword, bold = true })
hl("Exception",    { fg = colors.keyword, bold = true })

hl("PreProc",      { fg = colors.preproc })
hl("Include",      { fg = colors.string })
hl("Type",         { fg = colors.type, bold = true })
hl("Special",      { fg = colors.pop2 })
hl("SpecialChar",  { fg = colors.pop2 })
hl("Delimiter",    { fg = colors.fg })

hl("Underlined",   { underline = true })
hl("Error",        { fg = colors.pop2, bg = colors.bg })
hl("Todo",         { fg = colors.commentPop, bg = colors.bg, bold = true })
hl("Note",         { fg = colors.commentPop, bg = colors.bg, bold = true })

-- Tree-sitter Links
hl("@comment",             { link = "Comment" })
hl("@constant",            { link = "Constant" })
hl("@string",              { link = "String" })
hl("@number",              { link = "Number" })
hl("@boolean",             { link = "Boolean" })
hl("@function",            { link = "Function" })
hl("@function.builtin",    { fg = colors.pop1 })
hl("@keyword",             { link = "Keyword" })
hl("@keyword.function",    { link = "Keyword" })
hl("@operator",            { link = "Operator" })
hl("@type",                { link = "Type" })
hl("@type.builtin",        { link = "Type" })
hl("@variable",            { fg = colors.fg })
hl("@variable.builtin",    { fg = colors.keyword })
hl("@punctuation.delimiter",{ fg = colors.fg })
hl("@punctuation.bracket",  { fg = colors.fg })
hl("@property",            { fg = colors.fg })
hl("@field",               { fg = colors.fg })
hl("@tag",                 { fg = colors.keyword })
hl("@tag.attribute",       { fg = colors.fg, italic = false })
hl("@tag.delimiter",       { fg = colors.fg })

-- Gitsigns / Diagnostics
hl("DiagnosticError",         { fg = colors.pop2 })
hl("DiagnosticWarn",          { fg = colors.keyword })
hl("DiagnosticInfo",          { fg = colors.commentPop })
hl("DiagnosticHint",          { fg = colors.comment })

-- hl("statusline",              { bg = NONE })
-- hl("winbar",                  { bg = NONE })

