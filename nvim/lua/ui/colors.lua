local function hl(name, opts)
    opts.force = false
    vim.api.nvim_set_hl(0, name, opts)
end

local colors = {
    bg         = "#072626",   -- unchanged
    bgAlt      = "#1E2A2A",   -- slightly different dark shade
    fg         = "#A08563",   -- unchanged
    fgDim      = "#8C7A5A",   -- warmer dim foreground
    cursor     = "#FFD700",   -- golden cursor for visibility
    cursorAlt  = "#FF4500",   -- bright orange
    cursorLine = "#0A3B3B",   -- subtle highlight for current line
    lineNr     = "#606060",   -- slightly brighter
    lineNrBg   = "#1A1A1A",   -- darker background for line numbers
    visual     = "#556B2F",   -- olive green for selection
    search     = "#DAA520",   -- golden search highlight
    border     = "#303030",   -- neutral border
    comment    = "#6A6A6A",   -- cooler gray for comments
    commentPop = "#00CED1",   -- teal for emphasized comments
    keyword    = "#FF6347",   -- tomato red for keywords
    string     = "#32CD32",   -- lime green strings
    constant   = "#20B2AA",   -- light sea green for constants
    type       = "#D2B48C",   -- tan type color
    accent     = "#FFD700",   -- soft teal accent
    preproc    = "#FFA07A",   -- light salmon for preprocessor
    bar        = "#B0B0B0",   -- light gray for inactive bars
    barActive  = "#D3D3D3",   -- lighter gray for active bars
    pop1       = "#7CFC00",   -- lawn green popup
    pop2       = "#FF1493",   -- deep pink popup
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
hl("CursorLineNr", { fg = colors.accent, bold = false, bg = colors.cursorLine })
hl("LineNr",       { fg = colors.lineNr, bg = None })

hl("Visual",       { fg = "#aaaaaa", bg = colors.visual })
hl("MatchParen",   { fg = colors.bg, bg = colors.accent, bold = false })

hl("Search",       { bg = colors.search })
hl("IncSearch",    { fg = colors.bg, bg = colors.cursor })

hl("StatusLine",   { fg = colors.fg, bg = colors.bgAlt })
hl("StatusLineNC", { fg = colors.fgDim, bg = colors.bg })

hl("VertSplit",    { fg = colors.border, bg = "NONE" })
hl("WinSeparator", { fg = colors.border, bg = "NONE" })
hl("WinBar",       { fg = colors.bar, bg = "NONE", bold = false })

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
hl("Boolean",      { fg = colors.constant, bold = false })
hl("Float",        { fg = colors.constant })

hl("Identifier",   { fg = colors.fg })
hl("Function",     { fg = colors.fg, bold = false })

hl("Statement",    { fg = colors.keyword, bold = false })
hl("Conditional",  { fg = colors.keyword, bold = false })
hl("Repeat",       { fg = colors.keyword, bold = false })
hl("Label",        { fg = colors.keyword })
hl("Operator",     { fg = colors.fg })
hl("Keyword",      { fg = colors.keyword, bold = false })
hl("Exception",    { fg = colors.keyword, bold = false })

hl("PreProc",      { fg = colors.preproc })
hl("Include",      { fg = colors.string })
hl("Type",         { fg = colors.type, bold = false })
hl("Special",      { fg = colors.pop2 })
hl("SpecialChar",  { fg = colors.pop2 })
hl("Delimiter",    { fg = colors.fg })

hl("Underlined",   { underline = false })
hl("Error",        { fg = colors.pop2, bg = colors.bg })
hl("Todo",         { fg = colors.commentPop, bg = colors.bg, bold = false })
hl("Note",         { fg = colors.commentPop, bg = colors.bg, bold = false })

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

hl("statusline",              { bg = NONE })
hl("winbar",                  { bg = NONE })

