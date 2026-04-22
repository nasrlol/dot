-- AI generated build scripts too see to what extent we can have
local map = vim.keymap.set

---@return table { total_lines, total_files, by_ext }
local function count_loc()
    local result = { total_lines = 0, total_files = 0, by_ext = {} }
    local root = vim.fn.getcwd()
    local extensions = { "c", "h", "cpp", "cc", "cxx", "hpp" }

    local cmd = string.format( "find %s -type f -regextype posix-extended -regex '.*\\.(%s)$' 2>/dev/null", vim.fn.shellescape(root), table.concat(extensions, "|"))
    local files = vim.fn.systemlist(cmd)

    for _, filepath in ipairs(files) do
        local ext = filepath:match("%.([^.]+)$") or "?"
        local lines = tonumber(vim.fn.system("wc -l < " .. vim.fn.shellescape(filepath))) or 0
        result.total_lines = result.total_lines + lines
        result.total_files = result.total_files + 1
        result.by_ext[ext] = (result.by_ext[ext] or 0) + lines
    end

    return result
end

---@return table metrics containing compile_ms, link_ms, etc.
local function parse_build_metrics(qflist)
    local metrics = {
        compile_ms     = 0,
        link_ms        = 0,
        user_ms        = 0,
        sys_ms         = 0,
        real_ms        = 0,
        warnings       = 0,
        errors         = 0,
        files_compiled = 0,
    }

    for _, item in ipairs(qflist) do
        local text = item.text or ""

        if item.type == "E" then
            metrics.errors = metrics.errors + 1
        elseif item.type == "W" then
            metrics.warnings = metrics.warnings + 1
        end

        local compile_match = text:match("compilation took ([0-9.]+)ms")
        if compile_match then
            metrics.compile_ms = tonumber(compile_match)
        end

        local link_match = text:match("linking took ([0-9.]+)ms")
        if link_match then
            metrics.link_ms = tonumber(link_match)
        end

        -- `time` command output
        local real_min, real_sec = text:match("real%s+([0-9]+)m([0-9.]+)s")
        if real_min then
            metrics.real_ms = (tonumber(real_min) * 60 + tonumber(real_sec)) * 1000
        end

        local user_min, user_sec = text:match("user%s+([0-9]+)m([0-9.]+)s")
        if user_min then
            metrics.user_ms = (tonumber(user_min) * 60 + tonumber(user_sec)) * 1000
        end

        local sys_min, sys_sec = text:match("sys%s+([0-9]+)m([0-9.]+)s")
        if sys_min then
            metrics.sys_ms = (tonumber(sys_min) * 60 + tonumber(sys_sec)) * 1000
        end

        -- GCC/Clang -ftime-report
        local gcc_compile = text:match("preprocessing%s+:%s+([0-9.]+)s")
        if gcc_compile then
            metrics.compile_ms = tonumber(gcc_compile) * 1000
        end

        local gcc_link = text:match("assembler%s+:%s+([0-9.]+)s")
        if gcc_link then
            metrics.link_ms = tonumber(gcc_link) * 1000
        end

        local file_match = text:match("compiling ([%w_%.]+)")
        if file_match then
            metrics.files_compiled = metrics.files_compiled + 1
        end
    end

    return metrics
end

---@param metrics table
---@param total_ms number
---@param loc table
local function append_metrics_to_qf(metrics, total_ms, loc)
    local qflist = vim.fn.getqflist()

    local function entry(text)
        return { text = text, type = "", valid = 0 }
    end

    local summary = {
        entry(string.format("  total Time:      %.2f ms", total_ms)),
    }

    if metrics.real_ms > 0 then
        table.insert(summary, entry(string.format("  real time:       %.2f ms", metrics.real_ms)))
    end
    if metrics.user_ms > 0 then
        table.insert(summary, entry(string.format("  user time:       %.2f ms", metrics.user_ms)))
    end
    if metrics.sys_ms > 0 then
        table.insert(summary, entry(string.format("  system time:        %.2f ms", metrics.sys_ms)))
    end
    if metrics.compile_ms > 0 then
        table.insert(summary, entry(string.format("  compile time:    %.2f ms", metrics.compile_ms)))
    end
    if metrics.link_ms > 0 then
        table.insert(summary, entry(string.format("  link time:       %.2f ms", metrics.link_ms)))
    end
    if metrics.files_compiled > 0 then
        table.insert(summary, entry(string.format("  files compiled:  %d", metrics.files_compiled)))
    end
    if metrics.errors > 0 or metrics.warnings > 0 then
        table.insert(summary, entry(string.format("  errors: %d  warnings: %d", metrics.errors, metrics.warnings)))
    end

    table.insert(summary, entry("---------------------------------------------"))

    -- Per-extension breakdown, sorted descending by line count
    local exts = {}

    for ext, lines in pairs(loc.by_ext) do
        table.insert(exts, { ext = ext, lines = lines })
    end
    table.sort(exts, function(a, b) return a.lines > b.lines end)
    for _, v in ipairs(exts) do
        table.insert(summary, entry(string.format("    .%-6s %d lines", v.ext, v.lines)))
    end

    for _, line in ipairs(summary) do
        table.insert(qflist, line)
    end
    vim.fn.setqflist(qflist)
end

map("n", "<M-b>", function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= vim.api.nvim_get_current_win() then
            vim.api.nvim_win_close(win, true)
        end
    end
    local makeprg = vim.o.makeprg
    local start_time = vim.loop.hrtime()
    vim.cmd("cex system('" .. makeprg .. " 2>&1')")
    local end_time = vim.loop.hrtime()
    local total_ms = (end_time - start_time) / 1000000
    local metrics = parse_build_metrics(vim.fn.getqflist())
    local loc = count_loc()
    append_metrics_to_qf(metrics, total_ms, loc)
    -- Check if quickfix window is already open
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    if qf_winid == 0 then
        -- Open it if not
        local half = math.floor(vim.o.columns / 2)
        vim.cmd("vert copen " .. half)
    end
    vim.cmd("wincmd =")
    vim.cmd("wincmd l")  -- Move to quickfix window (right)
    vim.wo.wrap = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.cursorcolumn = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
    vim.cmd("wincmd h")  -- Move back to left window
end, { desc = "Run makeprg into vertical quickfix with metrics" })
