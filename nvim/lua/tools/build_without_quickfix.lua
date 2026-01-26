local M = {}
local map = vim.keymap.set

function M.setup()
  map("n", "<leader>cw", function()
    local cmd = { "make", "clean", "all" }

    vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
        if not res then
          vim.notify("Build command failed to execute", vim.log.levels.ERROR)
          return
        end

        if res.code == 0 then
          vim.notify("Build completed successfully", vim.log.levels.INFO)
        else
          local output = (res.stdout or "") .. (res.stderr or "")
          vim.notify("Build failed:\n" .. output, vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

return M
