-- Winbar: Context
function _G.custom_winbar()
  local file = vim.fn.expand("%:.")  -- Relative path
  if file == "" then file = "[No Name]" end

  local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
  local git = branch ~= "" and ("  " .. branch) or ""

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local diag = (errors > 0 and string.format("  %d", errors) or "") ..
               (warnings > 0 and string.format("  %d", warnings) or "")

  return string.format("  %s%s%s", file, git, diag)
end

-- Statusline: Status
function _G.custom_statusline()
  local mode_map = {
    n = "N", i = "I", v = "V", V = "VL", ["\22"] = "VB",
    c = "C", R = "R"
  }
  local mode = mode_map[vim.fn.mode()] or "?"

  local line = vim.fn.line(".")
  local total = vim.fn.line("$")
  local col = vim.fn.col(".")

  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "txt"
  local modified = vim.bo.modified and " ●" or ""

  return string.format(
    " %s | %s%s | %d:%d/%d ",
    mode, ft, modified, line, col, total
  )
end

-- vim.opt.winbar = "%{%v:lua.custom_winbar()%}"
vim.opt.statusline = "%!v:lua.custom_statusline()"
