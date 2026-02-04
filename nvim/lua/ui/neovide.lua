if vim.g.neovide then
    -- Font Configuration
    vim.o.guifont = "Liberation Mono:style=regular:h9"
    vim.opt.linespace = 8
    vim.g.neovide_scale_factor = 1.0

    -- Window & Display
    vim.g.neovide_refresh_rate = 240
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_no_idle = true
    vim.g.neovide_window_undecorated = true

    -- Transparency
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_window_floating_opacity = 0.95
    vim.g.neovide_floating_blur_amount_x = 0
    vim.g.neovide_floating_blur_amount_y = 0

    -- Cursor Appearance
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_smooth_blink = true
    vim.g.neovide_cursor_unfocused_outline_width = 0.125

    -- Cursor Animation
    vim.g.neovide_cursor_animation_length = 0.2
    vim.g.neovide_cursor_short_animation_length = 50
    vim.g.neovide_cursor_trail_size = 2
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true
    vim.g.neovide_cursor_vfx_mode = ""

    vim.g.neovide_scroll_animation_far_lines = 1

    vim.g.neovide_position_animation_length = 0.5

    -- Cursor VFX (disabled since vfx_mode is empty)
    vim.g.neovide_cursor_vfx_opacity = 400.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 2
    vim.g.neovide_cursor_vfx_particle_density = 9.0

    -- Input & Interaction
    vim.g.neovide_input_use_logo = true
    vim.g.neovide_touch_deadzone = 0.0
    vim.g.neovide_hide_mouse_when_typing = true

    -- Progress Bar
    vim.g.neovide_progress_bar_enabled = true
    vim.g.neovide_progress_bar_height = 5.0
    vim.g.neovide_progress_bar_animation_speed = 200.0
    vim.g.neovide_progress_bar_hide_delay = 0.2

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    -- Experimental/Fixes
    vim.g.neovide_cursor_hack = true

    vim.keymap.set('n', '<C-+>', function()
    local current = vim.o.guifont
    local size = tonumber(current:match(":h(%d+)"))
    if size then
        vim.o.guifont = current:gsub(":h%d+", ":h" .. (size + 1))
    end
end, { silent = true, desc = "Increase font size" })

vim.keymap.set('n', '<C-->', function()
    local current = vim.o.guifont
    local size = tonumber(current:match(":h(%d+)"))
    if size and size > 1 then
        vim.o.guifont = current:gsub(":h%d+", ":h" .. (size - 1))
    end
end, { silent = true, desc = "Decrease font size" })

vim.keymap.set('n', '<C-0>', function()
    vim.o.guifont = "Liberation Mono:style=regular:h8"
end, { silent = true, desc = "Reset font size" })
    vim.keymap.set('n', '<F11>', function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { silent = true, desc = "Toggle fullscreen" })
end
