-- better cd
vim.api.nvim_create_user_command("Z", function(opts)
  local query = table.concat(opts.fargs, " ")
  local handle = io.popen("zoxide query " .. vim.fn.shellescape(query))
  if not handle then return end
  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()
  if result ~= "" then
    vim.cmd.cd(result)
  else
    vim.notify("zoxide: no match", vim.log.levels.WARN)
  end
end, {
  nargs = "*",
  complete = function()
    return vim.fn.systemlist("zoxide query -l")
  end,
})

