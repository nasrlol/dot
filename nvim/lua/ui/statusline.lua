-- Cache values to reduce flickering
local cache = {
  git_branch = "",
  git_time = 0,
  char_info = "",
  last_col = 0,
  last_line = 0
}

-- Winbar: File Context + Git + Diagnostics
function _G.custom_winbar()
  local file = vim.fn.expand("%:.")
  if file == "" then file = "[No Name]" end

  -- Cache git branch (update every 5 seconds)
  local now = vim.loop.hrtime() / 1e9
  if now - cache.git_time > 5 then
    cache.git_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    cache.git_time = now
  end

  local git = cache.git_branch ~= "" and ("  " .. cache.git_branch) or ""

  -- Diagnostics (only count when diagnostics change)
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local diag = ""
  if errors > 0 then diag = diag .. string.format("  %d", errors) end
  if warnings > 0 then diag = diag .. string.format("  %d", warnings) end

  return string.format("  %s%s%s", file, git, diag)
end

-- Statusline: Mode + Position + FileInfo + ASCII
function _G.custom_statusline()
  local mode_map = {
    n = "N", i = "I", v = "V", V = "VL",
    ["\22"] = "VB", c = "C", R = "R",
    t = "T"
  }

  local mode = mode_map[vim.fn.mode()] or "?"
  local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "txt"
  local modified = vim.bo.modified and "●" or ""

  -- Position
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")
  local percent = math.floor((line / total) * 100)

  -- Cache character info only when cursor moves
  if cache.last_col ~= col or cache.last_line ~= line then
    local char = vim.fn.getline("."):sub(col, col)
    if char ~= "" and char ~= " " then
      local byte = string.byte(char)
      cache.char_info = string.format("0x%02X", byte)
    else
      cache.char_info = ""
    end
    cache.last_col = col
    cache.last_line = line
  end

  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding:upper() or "UTF-8"
  local format = vim.bo.fileformat:upper()

  -- Simple layout (no centering calculations every refresh)
  local left = string.format(" %s │ %s %s", mode, ft, modified)
  local right = string.format("%d:%d %d%% │ %s %s %s ",
    line, col, percent, encoding, format, cache.char_info)

  -- Center padding
  local padding = vim.o.columns - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right)
  if padding < 0 then padding = 0 end

  return left .. string.rep(" ", padding) .. right
end

vim.opt.winbar = "%{%v:lua.custom_winbar()%}"
vim.opt.statusline = "%!v:lua.custom_statusline()"


