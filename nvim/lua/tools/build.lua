 local function build_with_quickfix()
  return function()
    local win = vim.fn.win_getid()
    
    local cmd_str = vim.fn.expandcmd(vim.bo.makeprg)
    
    local cmd = vim.split(cmd_str, " ", { trimempty = true })

    if #cmd == 0 or cmd[1] == "" then
      vim.notify("makeprg is empty!", vim.log.levels.ERROR)
      return
    end

    vim.fn.setqflist({}, "r", { title = "Build: " .. cmd_str })

    vim.system(cmd, { text = true }, function(res)
      vim.schedule(function()
        local output = (res.stdout or "") .. (res.stderr or "")
        
        if #output > 0 then
          vim.fn.setqflist({}, "r", { 
            lines = vim.split(output, "\n"),
            efm = vim.bo.errorformat 
          })
          
          vim.cmd("noautocmd vertical copen | vertical resize " .. math.floor(vim.o.columns * 0.5))
          vim.fn.win_gotoid(win)
        else
          vim.notify("Build completed successfully: " .. cmd_str)
        end
      end)
    end)
  end
end


vim.keymap.set("n", "<F8>", build_with_quickfix(), { desc = "Run makeprg" })
