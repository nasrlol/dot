vim.keymap.set("n", "<leader>cc", function()
  local win = vim.fn.win_getid()
  local cmd = { "make", "clean", "all" }

  vim.fn.setqflist({}, "r")

  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if not res then
        vim.notify("Build command failed", vim.log.levels.ERROR)
        return
      end

      local lines = {}

      for _, src in ipairs({ res.stdout, res.stderr }) do
        if src and src ~= "" then
          for s in src:gmatch("[^\n]+") do
            table.insert(lines, s)
          end
        end
      end

      if #lines > 0 then
        vim.fn.setqflist({}, "r", { lines = lines })
        vim.cmd("noautocmd vertical copen")
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.5))
        vim.fn.win_gotoid(win)
      else
        vim.notify("Build completed successfully", vim.log.levels.INFO)
      end
    end)
  end)
end, { desc = "make clean all" })
