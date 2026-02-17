if vim.g.neovide then
    -- Font Configuration
    vim.o.guifont = "Liberation Mono:style=regular:h9"
    vim.opt.linespace = 0

    -- Scale Factor
    vim.g.neovide_scale_factor = 1

    -- Transparency
    vim.g.neovide_opacity =  0.9
    vim.g.neovide_window_blurred = true

    -- Floating Blur
    vim.g.neovide_floating_blur_amount_x = 0.5
    vim.g.neovide_floating_blur_amount_y = 0.5

    -- Floating Shadow
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 9

    -- Window Configuration
    vim.g.neovide_refresh_rate = 240
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_no_idle = true
    vim.g.neovide_remember_window_size = true

    -- Padding
    vim.g.neovide_padding_top = 30
    vim.g.neovide_padding_left = 30
    vim.g.neovide_padding_right = 30
    vim.g.neovide_padding_bottom = 30

    -- Background Color (not set - uses theme)

    -- Scroll Animation Length
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_scroll_animation_far_lines = 0

    -- Hiding the Mouse When Typing
    vim.g.neovide_hide_mouse_when_typing = true

    -- Underline Stroke Scale
    -- vim.g.neovide_underline_stroke_scale = 1.0

    -- Theme
    vim.g.neovide_theme = 'dark'

    -- Position Animation Length
    vim.g.neovide_position_animation_length = 1


    -- Cursor Settings
    vim.g.neovide_cursor_animation_length = 0.2
    vim.g.neovide_cursor_trail_size =  0.9
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true
    vim.g.neovide_cursor_unfocused_outline_width = 4
    vim.g.neovide_cursor_smooth_blink = true
    vim.g.neovide_cursor_short_animation_length = 200

    -- Cursor Particles
    vim.g.neovide_cursor_vfx_mode = ""
    vim.g.neovide_cursor_vfx_opacity = 0
    vim.g.neovide_cursor_vfx_particle_lifetime = 0
    vim.g.neovide_cursor_vfx_particle_density = 0
    -- vim.g.neovide_cursor_vfx_particle_speed = 10.0
    -- vim.g.neovide_cursor_vfx_particle_phase = 1.5
    -- vim.g.neovide_cursor_vfx_particle_curl = 1.0

    -- Touch Deadzone
    vim.g.neovide_touch_deadzone = 0.0

    -- Input Settings
    vim.g.neovide_input_use_logo = true

    -- Progress Bar Configuration
    vim.g.neovide_progress_bar_enabled = true
    vim.g.neovide_progress_bar_height = 5.0
    vim.g.neovide_progress_bar_animation_speed = 200.0
    vim.g.neovide_progress_bar_hide_delay = 0.2

    vim.opt.guicursor = "n-v-c:block-Cursor,i-ci:block-Cursor,r-cr:block-Cursor"

    -- Keybindings
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

    vim.keymap.set('n', '<C-0>', function() vim.o.guifont = "Liberation Mono:style=regular:h8"      end,    { silent = true, desc = "Reset font size" })
    vim.keymap.set('n', '<F11>', function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end,    { silent = true, desc = "Toggle fullscreen" })
end
