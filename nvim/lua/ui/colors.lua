-- Neovim Theme Configuration
-- Dark and Light mode support with unified colorscheme

function hl(name, opts)
    opts.force = false
    vim.api.nvim_set_hl(0, name, opts)
end

local dark = true

-- Color Palettes
local palettes = {
    dark = {
        bg         = "#0a0a0a",
        bgAlt      = "#1E2A2A",
        fg         = "#A08563",
        fgDim      = "#A08563",
        cursor     = "#1abc9c",
        cursorAlt  = "#A08563",
        cursorLine = "#A08563",
        lineNr     = "#A08563",
        visual     = "#A08563",
        search     = "#A08563",
        border     = "#A08563",
        comment    = "#A08563",
        commentPop = "#A08563",
        keyword    = "#A08563",
        string     = "#32CD32",
        constant   = "#A08563",
        type       = "#A08563",
        accent     = "#A08563",
        preproc    = "#A08563",
        bar        = NONE,
        pop1       = "#A08563",
        pop2       = "#A08563",

    },
    clear = {
        bg         = "#0a0a0a",
        bgAlt      = "#1E2A2A",
        fg         = "#A08563",
        fgDim      = "#5A5240",
        cursor     = "#1abc9c",
        cursorAlt  = "#FF4500",
        cursorLine = "#0A3B3B",
        lineNr     = "#606060",
        visual     = "#e53e10",
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
        bar        = NONE,
        pop1       = "#7CFC00",
        pop2       = "#FF1493",
    },
    light = {
        bg         = "#F5F1E8",
        bgAlt      = "#EBE4D9",
        fg         = "#3E3530",
        fgDim      = "#7A7066",
        cursor     = "#1A1A1A",
        cursorAlt  = "#D85D00",
        cursorLine = "#E8DDD0",
        lineNr     = "#9E9E9E",
        visual     = "#D95E15",
        search     = "#F0C000",
        border     = "#C8C8C8",
        comment    = "#8A8A7E",
        commentPop = "#0A9FB5",
        keyword    = "#C41E3A",
        string     = "#2F7A2F",
        constant   = "#1B8A8A",
        type       = "#8B7355",
        accent     = "#D4A000",
        preproc    = "#D97738",
        bar        = "#5A5A5A",
        pop1       = "#3F8D3F",
        pop2       = "#C9006B",
    }
}

local colors = palettes[dark and "dark" or "light"]

-- Helper function to apply highlights
local function apply_hl_group(group_name, opts)
    hl(group_name, opts)
end


apply_hl_group("Normal",      { fg = colors.fg,   bg = colors.bg,    blend = 10 })
apply_hl_group("NormalFloat", { fg = colors.fg,   bg = colors.bgAlt, blend = 10 })
apply_hl_group("NormalNC",    { fg = colors.fgDim, bg = colors.bg, blend = 10 })
apply_hl_group("WinBar",      { fg = colors.bar,  bg = NONE,    blend = 10 })
apply_hl_group("WinBarNC",    { fg = colors.fgDim, bg = NONE, blend = 10 })

-- Status Lines
apply_hl_group("statusline",   { fg = colors.fg,    bg = NONE,    blend = 10 })
apply_hl_group("statuslinenc", { fg = colors.fgDim, bg = NONE, blend = 10 })

-- Messages (Neovide-specific)
if vim.g.neovide then
    apply_hl_group("MsgArea",      { fg = colors.keyword, bg = colors.bg, blend = 10 })
    apply_hl_group("MsgSeparator", { fg = colors.border,  bg = colors.bg, blend = 10 })
    apply_hl_group("MoreMsg",      { fg = colors.accent,  bold = false,   blend = 10 })
    apply_hl_group("WarningMsg",   { fg = colors.pop2,                     blend = 10 })
else
    apply_hl_group("MsgArea",      { fg = "NONE", bg = "NONE" })
    apply_hl_group("MsgSeparator", { fg = "NONE", bg = "NONE" })
    apply_hl_group("MoreMsg",      { fg = "NONE", bold = false })
    apply_hl_group("WarningMsg",   { fg = "NONE" })
end


apply_hl_group("WinSeparator",   { fg = colors.fg,    bg = "NONE", blend = 10 })
apply_hl_group("WinSeparatorNC", { fg = colors.fgDim, bg = "NONE", blend = 10 })
apply_hl_group("VertSplit",      { fg = colors.border, bg = "NONE", blend = 10 })
apply_hl_group("VertSplitNC",    { fg = colors.fgDim, bg = "NONE", blend = 10 })

-- Float Border
apply_hl_group("FloatBorder",   { fg = colors.border, bg = colors.bgAlt, blend = 10 })
apply_hl_group("FloatBorderNC", { fg = colors.fgDim,  bg = colors.bgAlt, blend = 10 })


apply_hl_group("Cursor",        { fg = colors.bg, bg = colors.cursor,     blend = 10 })
apply_hl_group("TermCursor",    { fg = colors.bg, bg = colors.cursor,     blend = 10 })
apply_hl_group("CursorLine",    { bg = colors.cursorLine,                 blend = 10 })
apply_hl_group("CursorLineNC",  { bg = colors.bgAlt,                      blend = 10 })
apply_hl_group("CursorLineNr",  { fg = colors.accent, bg = colors.cursorLine, blend = 10 })
apply_hl_group("CursorLineNrNC",{ fg = colors.fgDim,  bg = colors.bgAlt,  blend = 10 })
apply_hl_group("LineNr",        { fg = colors.lineNr, bg = "NONE",        blend = 10 })
apply_hl_group("LineNrNC",      { fg = colors.fgDim,  bg = "NONE",        blend = 10 })


apply_hl_group("Visual",     { fg = colors.bg, bg = colors.visual,     blend = 10 })
apply_hl_group("VisualNC",   { fg = colors.fgDim, bg = colors.bgAlt,   blend = 10 })
apply_hl_group("Search",     { bg = colors.search,                      blend = 10 })
apply_hl_group("IncSearch",  { fg = colors.bg, bg = colors.visual,     blend = 10 })
apply_hl_group("MatchParen", { fg = colors.bg, bg = colors.accent,     blend = 10 })


apply_hl_group("Pmenu",        { fg = colors.fg,    bg = colors.bgAlt,  blend = 10 })
apply_hl_group("PmenuNC",      { fg = colors.fgDim, bg = colors.bgAlt,  blend = 10 })
apply_hl_group("PmenuSel",     { fg = colors.bg,    bg = colors.accent, blend = 10 })
apply_hl_group("PmenuSelNC",   { fg = colors.bgAlt, bg = colors.fgDim,  blend = 10 })
apply_hl_group("PmenuSbar",    { bg = colors.bgAlt,                      blend = 10 })
apply_hl_group("PmenuThumb",   { bg = colors.bar,                        blend = 10 })


apply_hl_group("Comment",      { fg = colors.comment,    italic = false, blend = 10 })
apply_hl_group("Constant",     { fg = colors.constant,                   blend = 10 })
apply_hl_group("String",       { fg = colors.string,                     blend = 10 })
apply_hl_group("Character",    { fg = colors.string,                     blend = 10 })
apply_hl_group("Number",       { fg = colors.constant,                   blend = 10 })
apply_hl_group("Boolean",      { fg = colors.constant, bold = false,     blend = 10 })
apply_hl_group("Float",        { fg = colors.constant,                   blend = 10 })
apply_hl_group("Identifier",   { fg = colors.fg,                         blend = 10 })
apply_hl_group("Function",     { fg = colors.fg, bold = false,           blend = 10 })
apply_hl_group("Statement",    { fg = colors.keyword, bold = false,      blend = 10 })
apply_hl_group("Conditional",  { fg = colors.keyword, bold = false,      blend = 10 })
apply_hl_group("Repeat",       { fg = colors.keyword, bold = false,      blend = 10 })
apply_hl_group("Label",        { fg = colors.keyword,                    blend = 10 })
apply_hl_group("Operator",     { fg = colors.fg,                         blend = 10 })
apply_hl_group("Keyword",      { fg = colors.keyword, bold = false,      blend = 10 })
apply_hl_group("Exception",    { fg = colors.keyword, bold = false,      blend = 10 })
apply_hl_group("PreProc",      { fg = colors.preproc,                    blend = 10 })
apply_hl_group("Include",      { fg = colors.string,                     blend = 10 })
apply_hl_group("Type",         { fg = colors.type, bold = false,         blend = 10 })
apply_hl_group("Special",      { fg = colors.pop2,                       blend = 10 })
apply_hl_group("SpecialChar",  { fg = colors.pop2,                       blend = 10 })
apply_hl_group("Delimiter",    { fg = colors.fg,                         blend = 10 })
apply_hl_group("Underlined",   { underline = false,                      blend = 10 })
apply_hl_group("Error",        { fg = colors.pop2, bg = colors.bg,       blend = 10 })
apply_hl_group("Todo",         { fg = colors.commentPop, bg = colors.bg, bold = false, blend = 10 })
apply_hl_group("Note",         { fg = colors.commentPop, bg = colors.bg, bold = false, blend = 10 })


apply_hl_group("DiagnosticError", { fg = colors.pop2,       blend = 10 })
apply_hl_group("DiagnosticWarn",  { fg = colors.keyword,    blend = 10 })
apply_hl_group("DiagnosticInfo",  { fg = colors.commentPop, blend = 10 })
apply_hl_group("DiagnosticHint",  { fg = colors.comment,    blend = 10 })


-- Basic Tree-sitter links
apply_hl_group("@comment",              { link = "Comment" })
apply_hl_group("@constant",             { link = "Constant" })
apply_hl_group("@string",               { link = "String" })
apply_hl_group("@number",               { link = "Number" })
apply_hl_group("@boolean",              { link = "Boolean" })
apply_hl_group("@function",             { link = "Function" })
apply_hl_group("@function.builtin",     { fg = colors.pop1 })
apply_hl_group("@keyword",              { link = "Keyword" })
apply_hl_group("@keyword.function",     { link = "Keyword" })
apply_hl_group("@operator",             { link = "Operator" })
apply_hl_group("@type",                 { link = "Type" })
apply_hl_group("@type.builtin",         { link = "Type" })
apply_hl_group("@variable",             { fg = colors.fg })
apply_hl_group("@variable.builtin",     { fg = colors.keyword })
apply_hl_group("@punctuation.delimiter",{ fg = colors.fg })
apply_hl_group("@punctuation.bracket",  { fg = colors.fg })
apply_hl_group("@property",             { fg = colors.fg })
apply_hl_group("@field",                { fg = colors.fg })
apply_hl_group("@tag",                  { fg = colors.keyword })
apply_hl_group("@tag.attribute",        { fg = colors.fg, italic = false })
apply_hl_group("@tag.delimiter",        { fg = colors.fg })

-- Type system highlights
apply_hl_group("@type.definition",      { fg = colors.type, bold = true })
apply_hl_group("@type.qualifier",       { fg = colors.keyword })
apply_hl_group("@type.int",             { fg = colors.constant })
apply_hl_group("@type.float",           { fg = colors.constant })
apply_hl_group("@type.bool",            { fg = colors.constant })
apply_hl_group("@type.char",            { fg = colors.string })
apply_hl_group("@type.void",            { fg = colors.keyword })
apply_hl_group("@type.ptr",             { fg = colors.preproc })

-- Declarations
apply_hl_group("@declaration.type",     { fg = colors.type, bold = true })
apply_hl_group("@declaration.var",      { fg = colors.fg })
apply_hl_group("@declaration.function", { fg = colors.fg })
apply_hl_group("@declaration.const",    { fg = colors.constant })

-- Modifiers & Storage
apply_hl_group("@modifier",             { fg = colors.keyword })
apply_hl_group("@modifier.const",       { fg = colors.keyword, italic = true })
apply_hl_group("@modifier.static",      { fg = colors.keyword, italic = true })
apply_hl_group("@modifier.extern",      { fg = colors.keyword, italic = true })
apply_hl_group("@modifier.volatile",    { fg = colors.keyword, italic = true })
apply_hl_group("@modifier.restrict",    { fg = colors.keyword, italic = true })
apply_hl_group("@storageclass",         { fg = colors.keyword })
apply_hl_group("@storageclass.typedef", { fg = colors.type, bold = true })
apply_hl_group("@storageclass.struct",  { fg = colors.type, bold = true })
apply_hl_group("@storageclass.union",   { fg = colors.type, bold = true })
apply_hl_group("@storageclass.enum",    { fg = colors.type, bold = true })

-- Field & Property
apply_hl_group("@field.type",           { fg = colors.type })
apply_hl_group("@property.type",        { fg = colors.type })

-- Function highlights
apply_hl_group("@function.call",        { fg = colors.fg })
apply_hl_group("@function.declaration", { fg = colors.fg, bold = true })
apply_hl_group("@function.type",        { fg = colors.type })

-- Parameters
apply_hl_group("@parameter",            { fg = colors.fg })
apply_hl_group("@parameter.type",       { fg = colors.type })
apply_hl_group("@variable.parameter",   { fg = colors.fg })

-- Type casting
apply_hl_group("@type.cast",            { fg = colors.type, italic = true })

-- Constants & Enums
apply_hl_group("@constant.builtin",     { fg = colors.constant })
apply_hl_group("@constant.macro",       { fg = colors.preproc })
apply_hl_group("@constant.type",        { fg = colors.type })

-- Aliases
apply_hl_group("@alias",                { fg = colors.type })
apply_hl_group("@type.alias",           { fg = colors.type, italic = true })

-- LSP highlights
apply_hl_group("@lsp.type.variable",   {})
apply_hl_group("@lsp.type.function",   {})
apply_hl_group("@lsp.type.keyword",    {})
apply_hl_group("@lsp.type.comment",    {})
apply_hl_group("@lsp.type.string",     {})
apply_hl_group("@lsp.type.number",     {})
apply_hl_group("@lsp.type.operator",   {})
apply_hl_group("@lsp.type.punctuation",{})


apply_hl_group("Normal", { fg = colors.fg, bg = colors.bg, blend = 10 })
