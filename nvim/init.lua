local opt = vim.opt

vim.loader.enable()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      columns = { "icon", "permissions", "size", "mtime" },
      view_options = {
        show_hidden = false,
        natural_order = true,
        is_always_hidden = function(name) return name == ".." end,
        sort = { { "type", "asc" }, { "name", "asc" } },
      },
      use_default_keymaps = false,
      keymaps = {
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["g."] = "actions.toggle_hidden",
        ["gs"] = "actions.change_sort",
        ["q"] = "actions.close",
      },
      skip_confirm_for_simple_edits = true,
      delete_to_trash = false,
      watch_for_changes = true,
      preview = { max_width = 0.9, min_width = 40 },
    },
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup()
      require("mini.starter").setup()
    end,
  },

  { "ibhagwan/fzf-lua", opts = {} },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "lua", "go", "rust" },
      highlight = { enable = true },
      indent = { enable = false },
    },
  },

  { "neovim/nvim-lspconfig" },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },
})

vim.diagnostic.config({
  float = {
    focusable = false,
    border = "rounded",
    source = "if_many",

    width = 160,
    max_width = 200,
    max_height = 50,
    wrap = true,

    scope = "line",
    header = "",
    prefix = "",
  },
})


local function open_diag_opposite()
  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)

  vim.diagnostic.open_float(0, {
    relative = "win",
    win = win,
    anchor = "NW",
    row = 0,
    col = width,
    border = "rounded",
    focusable = false,
    scope = "line",
    source = false,
    header = "",
    prefix = "",
    format = function(d)
      return d.message
    end,
  })
end

window = {
  completion = {
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine",
    scrollbar = false,
  },
  documentation = {
    border = "rounded",
    max_width = 60,
    max_height = 15,
  },
}

opt.cursorlineopt = "line"
opt.swapfile = false
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.number = true
opt.cursorline = true
opt.mouse = ""
opt.termguicolors = true
opt.updatetime = 400
opt.scrolloff = 18
opt.sidescrolloff = 18
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.equalalways = true
opt.signcolumn = "yes:1"
opt.showcmdloc = "statusline"
opt.cmdheight = 1
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.lazyredraw = true
opt.ttyfast = true
opt.joinspaces = false
opt.ignorecase = true
opt.smartcase = true
opt.winbar = table.concat({
  " %{toupper(mode())} ",        
  "%=",
  " %f",                          
  "%m",                            
  "%r",                             
  " ",
  "%=",
  " %y",                             
  " %{&fileencoding?&fileencoding:&encoding}",
  " %l:%c ",                    
})
opt.hlsearch = true
opt.incsearch = true
opt.laststatus = 0
opt.backspace = { "indent", "eol", "start" }
opt.keywordprg = ":help"
opt.confirm = true
opt.ruler = false
opt.showmode = false
opt.showcmd = true
opt.autochdir = false
opt.virtualedit = "block"
opt.list = false
opt.listchars = {
  space = "·", tab = "»·", trail = "•",
  extends = "›", precedes = "‹", nbsp = "␣",
}
opt.fillchars:append({ eob = " " })
opt.formatoptions:remove({ "c", "r", "o" })
opt.shortmess:append("c")
opt.guicursor = table.concat({
  "n:block-NeovideCursor",
  "i:ver25-NeovideCursor",
  "v:block-Neovide-Cursor",
  "c:hor20-NeovideCursor",
  "r:hor20-NeovideCursor",
}, ",")

opt.wildignore = {
  "*.o", "*.obj", "*.bin", "*.pyc",
  "__pycache__", "node_modules/*", ".git/*"
}

opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"
opt.cinoptions = table.concat({
  "g0",    
  "N-s",   
  "i2",    
  "t0",    
  "+2",    
  "(2",    
  "u0",    
  "w1",    
}, ",")

vim.g.mapleader = " "

local function apply_highlights()
  local hl = vim.api.nvim_set_hl

  hl(0, "Normal",       { fg = "#D4D4D4", bg = "#000000" })
  hl(0, "NormalNC",     { fg = "#D4D4D4", bg = "#000000" })
  hl(0, "NormalFloat",  { fg = "#D4D4D4", bg = "#000000" })
  hl(0, "EndOfBuffer",  { fg = "#000000", bg = "#000000" })
  hl(0, "StatusLine",   { fg = "#D4D4D4", bg = "NONE" })
  hl(0, "StatusLineNC", { fg = "#6B6B6B", bg = "NONE" })
  hl(0, "FloatBorder",  { fg = "#6B6B6B", bg = "#000000" })
  hl(0, "CursorLine",    { bg = "#1A1A1A" })
  hl(0, "LineNr",        { fg = "#404040" })
  hl(0, "CursorLineNr",  { fg = "#7FDA89", bold = true })
  hl(0, "Cursor",        { fg = "#000000", bg = "#7FDA89" })
  hl(0, "Comment",   { fg = "#6A9955", italic = true })
  hl(0, "@comment",  { fg = "#6A9955", italic = true })
  hl(0, "String",             { fg = "#CE9178" })
  hl(0, "Character",          { fg = "#CE9178" })
  hl(0, "@string",            { fg = "#CE9178" })
  hl(0, "@character",         { fg = "#CE9178" })
  hl(0, "@string.escape",     { fg = "#D7BA7D" })

  hl(0, "Keyword",   { fg = "#C586C0" })
  hl(0, "@keyword",  { fg = "#C586C0" })
  hl(0, "Type",     { fg = "#4EC9B0" })
  hl(0, "@type",    { fg = "#4EC9B0" })
  hl(0, "Function",   { fg = "#DCDCAA" })
  hl(0, "@function",  { fg = "#DCDCAA" })
  hl(0, "Identifier", { fg = "#D4D4D4" })
  hl(0, "@variable",  { fg = "#D4D4D4" })
  hl(0, "Number",   { fg = "#B5CEA8" })
  hl(0, "@number",  { fg = "#B5CEA8" })
  hl(0, "NotifyINFO",   { fg = "#B8B8B8" })
  hl(0, "NotifyWARN",   { fg = "#A0A0A0", bold = true })
  hl(0, "NotifyERROR",  { fg = "#888888", bold = true })
  hl(0, "NotifyDEBUG",  { fg = "#7A7A7A" })
  hl(0, "NotifyTRACE",  { fg = "#7A7A7A" })
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ui_group = augroup("UserUIAutocmds", { clear = true })

autocmd("ColorScheme", {
  group = ui_group,
  callback = apply_highlights,
})

autocmd("CursorHold", {
  group = ui_group,
  callback = function()
    vim.lsp.buf.document_highlight()
  end,
})

autocmd("CursorMoved", {
  group = ui_group,
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

autocmd({ "InsertLeave", "WinEnter" }, {
  group = ui_group,
  callback = function()
    vim.opt.cursorline = true
  end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
  group = ui_group,
  callback = function()
    vim.opt.cursorline = false
  end,
})




apply_highlights()

if vim.g.neovide then
  vim.api.nvim_set_hl(0, "NeovideCursor", { fg = "#000000", bg = "#7fda89" })
  vim.o.guifont = "JetbrainsMono Nerd Font:h8"
  vim.g.neovide_cursor_animation_length = 0.3
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_input_latency = 0
  vim.g.neovide_padding_left = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2
  vim.g.neovide_theme = 'dark'
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_refresh_rate = 240
  vim.g.neovide_no_idle = true
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_background_color = "#000000"

  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0
  vim.g.neovide_light_angle_degrees = 0
  vim.g.neovide_light_radius = 0

end
local map = vim.keymap.set
local opts = { silent = true }



-- format
map("n", "<leader>f", function()
  vim.lsp.buf.format()
end
)



local spinner = { "-", "\\", "|", "/" }
local idx = 1
local fzf = require("fzf-lua")

-- unbind arrow keys
map("", "<Up>", "<Nop>")
map("", "<Down>", "<Nop>")
map("", "<Left>", "<Nop>")
map("", "<Right>", "<Nop>")

-- better v mode nav
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- primaegan paste
map("x", "<leader>p", '"_dP', opts)

-- copy pasta
map("n", "<leader>yb", "<cmd>%y+<CR>")

-- convert file to hex
map("n", "<leader>hex", "<cmd>%!xxd<CR>")

-- fzf
map("n", "<leader>ff", fzf.files)
map("n", "<leader>gf", fzf.git_files)
map("n", "<leader>ts", fzf.treesitter)
map("n", "<leader>rr", fzf.diagnostics_workspace)
map("n", "<leader>fa", fzf.live_grep_native)
map("n", "<leader>cs", fzf.colorschemes)

-- lsp
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "gr", vim.lsp.buf.references)
map("n", "<leader>ci", vim.lsp.buf.incoming_calls)
map("n", "<leader>co", vim.lsp.buf.outgoing_calls)

-- clear search
map("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end)

-- remap command to make it easier
map("n", ";", ":")
map("n", ":", "<Nop>")

-- equals map
map("n", "=", function()
  vim.cmd("normal! ==")
end)

-- diagnostics navigation
map("n", "<leader>nr", vim.diagnostic.goto_next)
map("n", "<leader>pr", vim.diagnostic.goto_prev)

-- windows 
map("n", "<leader>vt", "<cmd>vsplit<CR>")
map("n", "<leader>ht", "<cmd>split<CR>")

-- diagnostics
map("n", "<leader>or", open_diag_opposite, { silent = true })

-- open terminal
map("n", "<leader>tt", "<cmd>botright 15split | term<CR>i")

-- ??
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- buffer keymaps
map("n", "<leader>b", ":ls<CR>:b ")
map("n", "<leader>bn", "<cmd>bnext<CR>")
map("n", "<leader>bp", "<cmd>bprevious<CR>")
map("n", "<leader>bb", "<cmd>buffer #<CR>")
map("n", "<leader>bc", "<cmd>confirm bdelete<CR>")

-- Oil
map("n", "<leader>ex", "<cmd>Oil<CR>")

-- ease of life
map("n", "<leader>w", "<cmd>w!<CR>")
map("n", "<leader>s", "<cmd>so ~/.config/nvim/init.lua<CR>")
map("n", "<leader>q", "<cmd>q<CR>")

-- motions
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- tabs
map("n", "<leader>nt", "<cmd>tabnew<CR>")

map("n", "<leader>-", function()
  vim.opt.list = not vim.opt.list:get()
end)


-- syntax based navigation

local pat = [[^\s*\(function\|func\|fn\)\>]]

map("n", "]f", function()
  vim.cmd("normal! /" .. pat .. "<CR>")
end)

map("n", "[f", function()
  vim.cmd("normal! ?" .. pat .. "<CR>")
end)


-- build
map("n", "<leader>cc", function()
  local win = vim.fn.win_getid()
  local cwd = vim.fn.getcwd()

  -- project-local override
  local script = vim.b.build_script or vim.g.build_script or "build.sh"
  local path = cwd .. "/" .. script

  local cmd = vim.fn.filereadable(path) == 1
  and { "sh", path }
  or { "cc", "-std=c11", "-Wall", "-Wextra", "-Werror", "-g", "*.c", "-o", "a.out" }

  vim.fn.setqflist({}, "r")

  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      local lines = {}

      if res.stdout and res.stdout ~= "" then
        for s in res.stdout:gmatch("[^\n]+") do
          table.insert(lines, s)
        end
      end
      if res.stderr and res.stderr ~= "" then
        for s in res.stderr:gmatch("[^\n]+") do
          table.insert(lines, s)
        end
      end

      if #lines > 0 then
        vim.fn.setqflist({}, "r", { lines = lines })
        vim.cmd("noautocmd vertical copen")
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.5))
        vim.fn.win_gotoid(win)
      end
    end)
  end)
end)


map("n", "<leader>tf", function()
  local cwd = vim.fn.getcwd()
  local build = cwd .. "/build.sh"

  local cmd = vim.fn.filereadable(build) == 1
  and { "sh", build }
  or { "cc", "-std=c11", "-Wall", "-Wextra", "-Werror", "-g", "*.c", "-o", "a.out" }

  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      local lines = {}

      if res.stdout and res.stdout ~= "" then
        for s in res.stdout:gmatch("[^\n]+") do
          table.insert(lines, s)
        end
      end

      if res.stderr and res.stderr ~= "" then
        for s in res.stderr:gmatch("[^\n]+") do
          table.insert(lines, s)
        end
      end

      if #lines == 0 then
        return
      end

      -- scratch buffer
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].filetype = "log"

      -- floating window
      local width  = math.floor(vim.o.columns * 0.7)
      local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.5))

      vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
        border = "rounded",
        style = "minimal",
      })
    end)
  end)
end)



-- close quick fix
map("n", "<leader>qc", "<cmd>cclose<CR>")

map("n", "<leader>gd", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      vim.lsp.buf.definition()
      return
    end
    vim.lsp.util.jump_to_location(result[1])
  end)
end)


-- enable lsp
vim.lsp.enable({ "gopls", "clangd" })
