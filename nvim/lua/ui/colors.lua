function hl(name, opts)
    opts.force = false
    vim.api.nvim_set_hl(0, name, opts)
end

local colors = {
    bg         = "#072626",
    bgAlt      = "#1E2A2A",
    fg         = "#A08563",
    fgDim      = "#5A5240",
    cursor     = "#88D700",
    cursorAlt  = "#FF4500",
    cursorLine = "#0A3B3B",
    lineNr     = "#606060",
    lineNrBg   = "#1A1A1A",
    visual     = "#224424",
    search     = "#DAA520",
    border     = "#303030",
    comment    = "#6A6A6A",
    commentPop = "#00CED1",
    keyword    = "#FF6347",
    string     = "#32CD32",
    constant   = "#20B2AA",
    type       = "#D2B48C",
    accent     = "#FFD700",
    preproc    = "#FFA07A",
    bar        = "#B0B0B0",
    barActive  = "#B0B0B0",
    pop1       = "#7CFC00",
    pop2       = "#FF1493",
}


dark = true

if dark then
    hl("Normal",        { fg = colors.fg,   bg = NONE  , blend=10})
    hl("NormalFloat",   { fg = colors.fg,   bg = NONE  , blend=10})
    hl("NormalNC",      { fg = colors.fgDim,bg = NONE  , blend=10})
    hl("WinBar",        { fg = colors.bar,  bg = NONE  , blend=10})
    hl("WinBarNC",      { fg = colors.fgDim,bg = NONE  , blend=10})
    hl("StatusLine",    { fg = colors.fg,    bg = NONE , blend=10})
    hl("StatusLineNC",  { fg = colors.fgDim, bg = NONE , blend=10})

    if  vim.g.neovide then
        hl("MsgArea",           { fg = colors.keyword, bg = "#0a0a0a", blend = 10 })
        hl("MsgSeparator",      { fg = colors.border, bg = "#0a0a0a", blend = 10 })
        hl("MoreMsg",           { fg = colors.accent, bold = false, blend = 10 })
        hl("WarningMsg",        { fg = colors.pop2, blend = 10 })
    else
        hl("MsgArea",           { fg = NONE ,bg = NONE })
        hl("MsgSeparator",      { fg = NONE ,bg = NONE })
        hl("MoreMsg",           { fg = NONE ,bold = false })
        hl("WarningMsg",        { fg = NONE })
    end

else
    -- Active window (bright, full contrast)
    hl("Normal",        { fg = colors.fg,    bg = colors.bg, blend = 10 })
    hl("NormalFloat",   { fg = colors.fg,    bg = colors.bg, blend = 10 })

    -- Inactive window (dimmed fg, slightly lighter bg for distinction)
    hl("NormalNC",      { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

    -- Window bars
    hl("WinBar",        { fg = colors.fg,    bg = colors.bg, blend = 10 })
    hl("WinBarNC",      { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

    -- Status lines
    hl("StatusLine",    { fg = colors.fg,    bg = colors.bg, blend = 10 })
    hl("StatusLineNC",  { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

    if  vim.g.neovide then
        hl("MsgArea",           { fg = colors.keyword, bg = colors.bg, blend = 10 })
        hl("MsgSeparator",      { fg = colors.border, bg = "#0a0a0a", blend = 10 })
        hl("MoreMsg",           { fg = colors.accent, bold = false, blend = 10 })
        hl("WarningMsg",        { fg = colors.pop2, blend = 10 })
    else
        hl("MsgArea",           { fg = NONE ,bg = NONE })
        hl("MsgSeparator",      { fg = NONE ,bg = NONE })
        hl("MoreMsg",           { fg = NONE ,bold = false })
        hl("WarningMsg",        { fg = NONE })
    end

end

-- Window Separators
hl("WinSeparator", { fg = colors.fg, bg = NONE, blend = 10 })
hl("WinSeparatorNC", { fg = colors.fgDim, bg = NONE, blend = 10 })

hl("VertSplit",    { fg = colors.border, bg = NONE, blend = 10 })
hl("VertSplitNC",  { fg = colors.fgDim, bg = NONE, blend = 10 })

-- Float Border
hl("FloatBorder",  { fg = colors.border, bg = colors.bgAlt, blend = 10 })
hl("FloatBorderNC",{ fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

-- Cursor
hl("Cursor",       { fg = colors.bg, bg = colors.cursor, blend = 10 })
hl("TermCursor",   { fg = colors.bg, bg = colors.cursor, blend = 10 })

-- Cursor Line & Line Numbers
hl("CursorLine",   { bg = colors.cursorLine, blend = 10 })
hl("CursorLineNC", { bg = colors.bgAlt, blend = 10 })

hl("CursorLineNr", { fg = colors.accent, bg = colors.cursorLine, blend = 10 })
hl("CursorLineNrNC", { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

hl("LineNr",       { fg = colors.lineNr, bg = NONE, blend = 10 })
hl("LineNrNC",     { fg = colors.fgDim, bg = NONE, blend = 10 })

-- Selection
hl("Visual",       { fg = colors.fg, bg = colors.visual, blend = 10 })
hl("VisualNC",     { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

hl("MatchParen",   { fg = colors.bg, bg = colors.accent, blend = 10 })

-- Search
hl("Search",       { bg = colors.search, blend = 10 })
hl("IncSearch",    { fg = colors.bg, bg = colors.cursor, blend = 10 })

-- Completion Menu
hl("Pmenu",        { fg = colors.fg, bg = colors.bgAlt, blend = 10 })
hl("PmenuNC",      { fg = colors.fgDim, bg = colors.bgAlt, blend = 10 })

hl("PmenuSel",     { fg = colors.bg, bg = colors.accent, blend = 10 })
hl("PmenuSelNC",   { fg = colors.bgAlt, bg = colors.fgDim, blend = 10 })

hl("PmenuSbar",    { bg = colors.bgAlt, blend = 10 })
hl("PmenuThumb",   { bg = colors.bar, blend = 10 })

if true then

-- Syntax Highlighting
hl("Comment",      { fg = colors.comment, italic = false, blend = 10 })
hl("Constant",     { fg = colors.constant, blend = 10 })
hl("String",       { fg = colors.string, blend = 10 })
hl("Character",    { fg = colors.string, blend = 10 })
hl("Number",       { fg = colors.constant, blend = 10 })
hl("Boolean",      { fg = colors.constant, bold = false, blend = 10 })
hl("Float",        { fg = colors.constant, blend = 10 })

hl("Identifier",   { fg = colors.fg, blend = 10 })
hl("Function",     { fg = colors.fg, bold = false, blend = 10 })

hl("Statement",    { fg = colors.keyword, bold = false, blend = 10 })
hl("Conditional",  { fg = colors.keyword, bold = false, blend = 10 })
hl("Repeat",       { fg = colors.keyword, bold = false, blend = 10 })
hl("Label",        { fg = colors.keyword, blend = 10 })
hl("Operator",     { fg = colors.fg, blend = 10 })
hl("Keyword",      { fg = colors.keyword, bold = false, blend = 10 })
hl("Exception",    { fg = colors.keyword, bold = false, blend = 10 })

hl("PreProc",      { fg = colors.preproc, blend = 10 })
hl("Include",      { fg = colors.string, blend = 10 })
hl("Type",         { fg = colors.type, bold = false, blend = 10 })
hl("Special",      { fg = colors.pop2, blend = 10 })
hl("SpecialChar",  { fg = colors.pop2, blend = 10 })
hl("Delimiter",    { fg = colors.fg, blend = 10 })

hl("Underlined",   { underline = false, blend = 10 })
hl("Error",        { fg = colors.pop2, bg = colors.bg, blend = 10 })
hl("Todo",         { fg = colors.commentPop, bg = colors.bg, bold = false, blend = 10 })
hl("Note",         { fg = colors.commentPop, bg = colors.bg, bold = false, blend = 10 })

-- Gitsigns / Diagnostics
hl("DiagnosticError",         { fg = colors.pop2, blend = 10 })
hl("DiagnosticWarn",          { fg = colors.keyword, blend = 10 })
hl("DiagnosticInfo",          { fg = colors.commentPop, blend = 10 })
hl("DiagnosticHint",          { fg = colors.comment, blend = 10 })

end

if true then
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


-- Base Types
hl("@type",                   { fg = colors.type, bold = false })
hl("@type.builtin",           { fg = colors.type })
hl("@type.definition",        { fg = colors.type, bold = true })
hl("@type.qualifier",         { fg = colors.keyword })

-- Primitive Types (C)
hl("@type.int",               { fg = colors.constant })
hl("@type.float",             { fg = colors.constant })
hl("@type.bool",              { fg = colors.constant })
hl("@type.char",              { fg = colors.string })
hl("@type.void",              { fg = colors.keyword })
hl("@type.ptr",               { fg = colors.preproc })

-- Declarations
hl("@declaration.type",       { fg = colors.type, bold = true })
hl("@declaration.var",        { fg = colors.fg })
hl("@declaration.function",   { fg = colors.fg })
hl("@declaration.const",      { fg = colors.constant })

-- Qualifiers (const, volatile, etc.)
hl("@modifier",               { fg = colors.keyword })
hl("@modifier.const",         { fg = colors.keyword, italic = true })
hl("@modifier.static",        { fg = colors.keyword, italic = true })
hl("@modifier.extern",        { fg = colors.keyword, italic = true })
hl("@modifier.volatile",      { fg = colors.keyword, italic = true })
hl("@modifier.restrict",      { fg = colors.keyword, italic = true })

-- Storage Classes
hl("@storageclass",           { fg = colors.keyword })
hl("@storageclass.typedef",   { fg = colors.type, bold = true })
hl("@storageclass.struct",    { fg = colors.type, bold = true })
hl("@storageclass.union",     { fg = colors.type, bold = true })
hl("@storageclass.enum",      { fg = colors.type, bold = true })

-- Struct/Union Members & Properties
hl("@field",                  { fg = colors.fg })
hl("@field.type",             { fg = colors.type })
hl("@property",               { fg = colors.fg })
hl("@property.type",          { fg = colors.type })

-- Function Types
hl("@function",               { fg = colors.fg, bold = false })
hl("@function.call",          { fg = colors.fg })
hl("@function.builtin",       { fg = colors.pop1 })
hl("@function.declaration",   { fg = colors.fg, bold = true })
hl("@function.type",          { fg = colors.type })

-- Parameters & Arguments
hl("@parameter",              { fg = colors.fg })
hl("@parameter.type",         { fg = colors.type })
hl("@variable.parameter",     { fg = colors.fg })

-- Type Casts & Conversions
hl("@type.cast",              { fg = colors.type, italic = true })

-- Enums & Constants
hl("@constant",               { fg = colors.constant })
hl("@constant.builtin",       { fg = colors.constant })
hl("@constant.macro",         { fg = colors.preproc })
hl("@constant.type",          { fg = colors.type })

-- Typedefs & Aliases
hl("@alias",                  { fg = colors.type })
hl("@type.alias",             { fg = colors.type, italic = true })

hl("@type",              { fg = colors.type })
hl("@type.builtin",      { fg = colors.constant })
hl("@type.definition",   { fg = colors.type, bold = true })
hl("@keyword.type",      { fg = colors.keyword })
hl("@storageclass",      { fg = colors.keyword })

end
