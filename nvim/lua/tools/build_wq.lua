local M = {}

function M.setup()
  vim.keymap.set("n", "<leader>cw", function()
    vim.system({ "make", "clean", "all" }, { text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("Build completed successfully")
        else
          vim.notify("Build failed:\n" .. (res.stderr or res.stdout or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end, { desc = "Clean and build project" })
end

return M
