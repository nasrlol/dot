-- ============================================================================
-- Highlight helper
-- ============================================================================

local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

-- ============================================================================
-- Color palette
-- ============================================================================

local colors = {
  fg           = "#ffffff",
  gutter       = "#3b4261",

  cyan         = "#4fd6be",
  blue         = "#7aa2f7",
  purple       = "#bb9af7",
  pink         = "#f7768e",

  green        = "#9ece6a",
  light_green  = "#73daca",

  yellow       = "#e0af68",
  orange       = "#ff9e64",
  red          = "#f7768e",
}

-- ============================================================================
-- Treesitter / LSP semantic highlights
-- ============================================================================

local groups = {
  -- Functions / methods
  ["@function"]           = { fg = colors.cyan },
  ["@function.call"]      = { fg = colors.cyan },
  ["@function.builtin"]   = { fg = colors.blue },
  ["@method"]             = { fg = colors.cyan },
  ["@method.call"]        = { fg = colors.cyan },

  -- Variables
  ["@variable"]           = { fg = colors.fg },
  ["@variable.builtin"]   = { fg = colors.purple },
  ["@parameter"]          = { fg = colors.orange },
  ["@field"]              = { fg = colors.light_green },
  ["@property"]           = { fg = colors.light_green },

  -- Types
  ["@type"]               = { fg = colors.yellow },
  ["@type.builtin"]       = { fg = colors.yellow },
  ["@type.definition"]    = { fg = colors.yellow },
  ["@constructor"]        = { fg = colors.yellow },

  -- Keywords
  ["@keyword"]            = { fg = colors.pink },
  ["@keyword.function"]   = { fg = colors.pink },
  ["@keyword.return"]     = { fg = colors.pink },
  ["@keyword.operator"]   = { fg = colors.pink },
  ["@keyword.type"]       = { fg = colors.pink },

  -- Constants / enums
  ["@constant"]           = { fg = colors.orange },
  ["@constant.builtin"]   = { fg = colors.orange },
  ["@enum"]               = { fg = colors.yellow },
  ["@enumMember"]         = { fg = colors.orange },

  -- Literals
  ["@string"]             = { fg = colors.green },
  ["@string.escape"]      = { fg = colors.cyan },
  ["@character"]          = { fg = colors.green },
  ["@number"]             = { fg = colors.orange },
  ["@float"]              = { fg = colors.orange },
  ["@boolean"]            = { fg = colors.orange },

  -- Operators / punctuation
  ["@operator"]                   = { fg = colors.pink },
  ["@punctuation.delimiter"]      = { fg = colors.fg },
  ["@punctuation.bracket"]        = { fg = colors.fg },
  ["@punctuation.special"]        = { fg = colors.pink },

  -- Preprocessor (C/C++)
  ["@preproc"]            = { fg = colors.purple },
  ["@include"]            = { fg = colors.purple },
  ["@define"]             = { fg = colors.purple },
  ["@macro"]              = { fg = colors.purple },

  -- Comments
  ["@comment"]            = { fg = colors.gutter, italic = true },
  ["@comment.todo"]       = { fg = colors.yellow, bold = true },
  ["@comment.warning"]    = { fg = colors.orange, bold = true },
  ["@comment.error"]      = { fg = colors.red, bold = true },

  -- Namespaces / modules
  ["@namespace"]          = { fg = colors.blue },
  ["@module"]             = { fg = colors.blue },

  -- Labels
  ["@label"]              = { fg = colors.cyan },

  -- Attributes (clang)
  ["@attribute"]          = { fg = colors.purple },
  ["@attribute.builtin"]  = { fg = colors.purple },
}

-- ============================================================================
-- Apply highlights
-- ============================================================================

for group, opts in pairs(groups) do
  hl(group, opts)
end
