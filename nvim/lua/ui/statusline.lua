-- Helpers
function _G.filepath()
  local path = vim.fn.expand("%:p")
  if path == "" then return "[No File]" end
  return path:gsub("^" .. vim.loop.os_homedir(), "~")
end

function _G.char_info()
  local ch = vim.fn.getline("."):sub(vim.fn.col("."), vim.fn.col("."))
  if ch == "" then return "∅" end
  local byte = ch:byte()
  return string.format("'%s' %d 0x%X", ch, byte, byte)
end

function _G.diagnostics()
  local c = vim.diagnostic.count(0)
  local e = c[1] or 0
  local w = c[2] or 0
  if e + w == 0 then return "OK" end
  return string.format("E:%d W:%d", e, w)
end

function _G.lsp()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  return clients[1] and clients[1].name or "NoLSP"
end

-- Statusline
vim.opt.statusline = " %{mode()} | %{%v:lua.filepath()%} | %{%v:lua.char_info()%}"
  .. "%=%{%v:lua.diagnostics()%} | %y | %l:%c | %p%% | %{%v:lua.lsp()%} "
