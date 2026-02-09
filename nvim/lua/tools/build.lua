local function build_with_quickfix(cmd, desc)
  return function()
    local win = vim.fn.win_getid()
    vim.fn.setqflist({}, "r")

    vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
        local output = (res.stdout or "") .. (res.stderr or "")
        local lines = vim.split(output, "\n", { trimempty = true })

        if #lines > 0 then
          vim.fn.setqflist({}, "r", { lines = lines })
          vim.cmd("noautocmd vertical copen | vertical resize " .. math.floor(vim.o.columns * 0.5))
          vim.fn.win_gotoid(win)
        else
          vim.notify("Build completed successfully")
        end
      end)
    end)
  end
end

vim.keymap.set("n", "<leader>cq", build_with_quickfix(
  { "make", "clean", "all" },
  "Build and output to quickfix"
))

vim.keymap.set("n", "<leader>cr", build_with_quickfix(
  { "make", "clean", "run" },
  "Build and run project"
))

vim.keymap.set("n", "<leader>cb", build_with_quickfix(
  { "./source/build.sh" },
  "Run build.sh"
))

vim.keymap.set("n", "<leader>cB", build_with_quickfix(
  { "./source/build.sh", "run" },
  "Run build.sh run"
))
