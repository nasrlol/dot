fontsize = 13
opt.linespace = 2

function set_fontsize()
    o.guifont = "comic mono:h" .. fontsize
end
set_fontsize()


if vim.g.neovide then

    -- Cursor settings
    opt.guicursor = "n-v-c-i-ci-r-cr:block-Cursor,o:hor50-Cursor"

    g.neovide_theme                             = 'dark'
    g.neovide_scale_factor                      = 1
    g.neovide_opacity                           = 0.98

    -- Disable visual bloat
    g.neovide_floating_blur_amount_x            = 0.8
    g.neovide_floating_blur_amount_y            = 0.8
    g.neovide_floating_z_height                 = 0.8
    g.neovide_light_angle_degrees               = 0
    g.neovide_light_radius                      = 0
    g.neovide_floating_shadow                   = false
    g.neovide_window_blurred                    = true


    -- Refresh rate
    g.neovide_refresh_rate                      = 60
    g.neovide_refresh_rate_idle                 = 60

    g.neovide_padding_top = 0
    g.neovide_padding_bottom = 0
    g.neovide_padding_right = 0
    g.neovide_padding_left = 0

    -- Animations
    g.neovide_cursor_animation_length        = 0.09
    g.neovide_position_animation_length      = 0.0
    g.neovide_scroll_animation_length        = 0.0
    g.neovide_scroll_animation_far_lines     = 1
    g.neovide_underline_stroke_scale         = 1
    g.neovide_cursor_trail_size              = 20

    -- Cursor VFX (disabled for now)
    g.neovide_cursor_vfx_particle_density       = 0
    g.neovide_cursor_vfx_opacity                = 0
    g.neovide_cursor_vfx_particle_lifetime      = 0
    g.neovide_cursor_vfx_mode                   = ""

    -- Cursor behavior
    g.neovide_cursor_animate_in_insert_mode     = true
    g.neovide_cursor_animate_command_line       = false
    g.neovide_cursor_smooth_blink               = false
    g.neovide_cursor_unfocused_outline_width    = 0

    g.neovide_progress_bar_enabled = true
    g.neovide_progress_bar_height = 5.0
    g.neovide_progress_bar_animation_speed = 200.0
    g.neovide_progress_bar_hide_delay = 0.2

    -- Input & performance
    g.neovide_input_use_logo                    = false
    g.neovide_no_idle                           = false
    g.neovide_cursor_antialiasing               = false


    g.neovide_hide_mouse_when_typing            = true
end
