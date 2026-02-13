vim.cmd("hi clear")

local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

local palettes = {}

palettes.dark = {
  bg         = "#000000", -- true black
  bgAlt     = "#000000",
  fg         = "#ffffff", -- hard white
  fgDim      = "#bfbfbf",
  cursor     = "#00ff00", -- neon green
  cursorLine = "#0a0a0a",
  lineNr     = "#404040",
  visual     = "#1a1a1a",
  accent     = "#ff0000", -- strong red
  comment    = "#606060",
  dim        = "#707070",
}

palettes.light = {
  bg        = "#ffffff",
  bgAlt     = "#f2f2f2",

  fg        = "#000000",
  fgDim     = "#333333",

  cursor    = "#00aa00",  -- green cursor
  cursorLine= "#eaeaea",
  lineNr    = "#888888",
  visual    = "#dddddd",

  accent    = "#ff0000",  -- strong red
  bright    = "#000000",
  medium    = "#444444",
  dim       = "#777777",
  comment   = "#999999",
}


local function apply_theme(colors)
  vim.o.background = (colors.bg == palettes.light.bg) and "light" or "dark"

  -- UI
  hl("Normal",        { fg = colors.fg, bg = NONE })
  hl("CursorLine",    { bg = colors.cursorLine })
  hl("CursorLineNr",  { fg = colors.accent, bold = true })
  hl("LineNr",        { fg = colors.lineNr })
  hl("Visual",        { bg = colors.visual })
  hl("MatchParen",    { fg = colors.accent, bold = true })

  hl("StatusLine",    { fg = colors.fg, bg = colors.bgAlt })
  hl("StatusLineNC",  { fg = colors.medium, bg = colors.bgAlt })
  hl("WinBar",        { fg = colors.bright, bg = colors.bgAlt })

  -- Core syntax
  hl("@keyword",      { fg = colors.accent, bold = true })
  hl("@function",     { fg = colors.accent, bold = true })
  hl("@type",         { fg = colors.bright })
  hl("@constant",     { fg = colors.bright })
  hl("@string",       { fg = colors.medium })
  hl("@number",       { fg = colors.bright })
  hl("@comment",      { fg = colors.comment, italic = true })

  -- Punctuation
  hl("@operator",              { fg = colors.medium })
  hl("@punctuation.delimiter", { fg = colors.dim })
  hl("@punctuation.bracket",   { fg = colors.dim })

  -- Floats
  hl("NormalFloat",   { fg = colors.fg, bg = colors.bgAlt })
  hl("FloatBorder",   { fg = colors.accent, bg = colors.bgAlt })

  -- Completion
  hl("Pmenu",      { fg = colors.fg, bg = colors.bgAlt })
  hl("PmenuSel",   { fg = colors.bg, bg = colors.accent })

  -- Cursor
  hl("Cursor",   { fg = colors.bg, bg = colors.cursor })
end


_G.my_theme_state = _G.my_theme_state or "dark"

local function toggle_theme()
  if _G.my_theme_state == "dark" then
    _G.my_theme_state = "light"
  else
    _G.my_theme_state = "dark"
  end
  apply_theme(palettes[_G.my_theme_state])
end

apply_theme(palettes[_G.my_theme_state])

vim.keymap.set("n", "<leader>tt", toggle_theme)
