 -- retrobox.lua
-- A clean, red-accented monochrome theme with light/dark toggle.

-- 1. Reset built-in colors to ensure clean slate
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "retrobox"

-- 2. Define Helper for setting highlights
local function hl(name, opts)
  -- Force 'force' to true to override any existing plugin defaults
  opts.force = true
  vim.api.nvim_set_hl(0, name, opts)
end

-- 3. Palettes: Cleaned up for better separation and readability
local palettes = {}

palettes.dark = {
  bg         = "#0a0a0a", -- "Ink Black" (softer than #000000)
  bgAlt      = "#141414", -- Status lines / floating windows
  fg         = "#e6e6e6", -- Off-white (easier on eyes than #ffffff)
  fgDim      = "#707070", -- Non-essential text
  
  -- UI Elements
  cursor     = "#44dd44", -- Bright red cursor
  cursorLine = "#1a1a1a", -- Subtle background for current line
  lineNr     = "#353535", -- Dark grey line numbers
  visual     = "#333333", -- Selection background
  search     = "#aa0000", -- Search background
  
  -- Syntax Colors
  accent     = "#d72020", -- Primary Red Accent (Variables, keywords)
  comment    = "#555555", -- Legible grey
  constant   = "#ff6666", -- Lighter red for constants/numbers
  string     = "#999999", -- Silver for strings
  type       = "#ff4444", -- Bold red for types
  
  border     = "#333333", -- Split/Window borders
}

palettes.light = {
  bg         = "#fafafa", -- "Paper White" (softer than #ffffff)
  bgAlt      = "#f0f0f0",
  fg         = "#1c1c1c", -- Soft Black
  fgDim      = "#888888",
  
  -- UI Elements
  cursor     = "#d70000",
  cursorLine = "#eeeeee",
  lineNr     = "#cccccc",
  visual     = "#e0e0e0",
  search     = "#ffcccc",
  
  -- Syntax Colors
  accent     = "#c00000", -- Deep Red
  comment    = "#999999",
  constant   = "#aa0000",
  string     = "#555555",
  type       = "#d70000",
  
  border     = "#dddddd",
}

-- 4. Theme Application Logic
local function apply_theme(colors)
  vim.o.background = (colors.bg == palettes.light.bg) and "light" or "dark"

  -----------------------------------------------------------------------------
  -- UI / Editor Elements
  -----------------------------------------------------------------------------
  hl("Normal",       { fg = colors.fg, bg = colors.bg })
  hl("NormalFloat",  { fg = colors.fg, bg = colors.bgAlt })
  hl("FloatBorder",  { fg = colors.accent, bg = colors.bgAlt })
  
  hl("Cursor",       { fg = colors.bg, bg = colors.cursor })
  hl("TermCursor",   { fg = colors.bg, bg = colors.cursor })
  
  hl("CursorLine",   { bg = colors.cursorLine })
  hl("CursorLineNr", { fg = colors.accent, bold = true, bg = colors.cursorLine })
  hl("LineNr",       { fg = colors.lineNr })
  
  hl("Visual",       { bg = colors.visual, bold = true })
  hl("MatchParen",   { fg = colors.bg, bg = colors.accent, bold = true })
  
  hl("Search",       { fg = "#ffffff", bg = colors.search, bold = true })
  hl("IncSearch",    { fg = colors.bg, bg = colors.cursor })
  
  hl("StatusLine",   { fg = colors.fg, bg = colors.bgAlt })
  hl("StatusLineNC", { fg = colors.fgDim, bg = colors.bg })
  
  hl("VertSplit",    { fg = colors.border, bg = "NONE" })
  hl("WinSeparator", { fg = colors.border, bg = "NONE" })
  hl("WinBar",       { fg = colors.accent, bg = "NONE", bold = true })

  hl("Pmenu",        { fg = colors.fg, bg = colors.bgAlt })
  hl("PmenuSel",     { fg = colors.bg, bg = colors.accent, bold = true })
  hl("PmenuSbar",    { bg = colors.bgAlt })
  hl("PmenuThumb",   { bg = colors.fgDim })

  -----------------------------------------------------------------------------
  -- Syntax Highlighting
  -----------------------------------------------------------------------------
  hl("Comment",      { fg = colors.comment, italic = true })
  hl("Constant",     { fg = colors.constant })
  hl("String",       { fg = colors.string })
  hl("Character",    { fg = colors.string })
  hl("Number",       { fg = colors.constant })
  hl("Boolean",      { fg = colors.accent, bold = true })
  hl("Float",        { fg = colors.constant })

  hl("Identifier",   { fg = colors.fg })
  hl("Function",     { fg = colors.fg, bold = true }) -- Functions plain, let keywords pop

  hl("Statement",    { fg = colors.accent, bold = true })
  hl("Conditional",  { fg = colors.accent, bold = true })
  hl("Repeat",       { fg = colors.accent, bold = true })
  hl("Label",        { fg = colors.accent })
  hl("Operator",     { fg = colors.fgDim }) -- Operators subtle
  hl("Keyword",      { fg = colors.accent, bold = true })
  hl("Exception",    { fg = colors.accent, bold = true })

  hl("PreProc",      { fg = colors.accent })
  hl("Type",         { fg = colors.type, bold = true })
  hl("Special",      { fg = colors.accent })
  hl("Delimiter",    { fg = colors.fgDim })
  
  hl("Underlined",   { underline = true })
  hl("Error",        { fg = colors.bg, bg = colors.accent })
  hl("Todo",         { fg = colors.bg, bg = colors.accent, bold = true })

  -----------------------------------------------------------------------------
  -- Tree-sitter Links (Maps TS groups to our defined groups)
  -----------------------------------------------------------------------------
  hl("@comment",             { link = "Comment" })
  hl("@constant",            { link = "Constant" })
  hl("@string",              { link = "String" })
  hl("@number",              { link = "Number" })
  hl("@boolean",             { link = "Boolean" })
  hl("@function",            { link = "Function" })
  hl("@function.builtin",    { link = "Special" })
  hl("@keyword",             { link = "Keyword" })
  hl("@keyword.function",    { link = "Keyword" })
  hl("@operator",            { link = "Operator" })
  hl("@type",                { link = "Type" })
  hl("@type.builtin",        { link = "Type" })
  hl("@variable",            { fg = colors.fg })
  hl("@variable.builtin",    { fg = colors.accent })
  hl("@punctuation.delimiter",{ fg = colors.fgDim })
  hl("@punctuation.bracket",  { fg = colors.fgDim })
  hl("@property",            { fg = colors.fg })
  hl("@field",               { fg = colors.fg })
  hl("@tag",                 { fg = colors.accent })
  hl("@tag.attribute",       { fg = colors.fg, italic = true })
  hl("@tag.delimiter",       { fg = colors.fgDim })

  -- Gitsigns / Diagnostics
  hl("DiagnosticError",         { fg = colors.accent })
  hl("DiagnosticWarn",          { fg = colors.constant })
  hl("DiagnosticInfo",          { fg = colors.string })
  hl("DiagnosticHint",          { fg = colors.comment })
end

-- 5. State Management & Toggle Function
_G.retrobox_state = _G.retrobox_state or "dark"

local function toggle_theme()
  _G.retrobox_state = (_G.retrobox_state == "dark") and "light" or "dark"
  apply_theme(palettes[_G.retrobox_state])
  print("Retrobox: " .. _G.retrobox_state .. " mode")
end

-- 6. Initialize Theme
apply_theme(palettes[_G.retrobox_state])

-- 7. Keybinding
vim.keymap.set("n", "<leader>tt", toggle_theme, { desc = "Toggle Retrobox Theme" })

return {
  toggle = toggle_theme
}
