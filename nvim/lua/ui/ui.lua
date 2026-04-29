fontsize = 8
opt.linespace = -3

function set_fontsize()
    o.guifont = "Courier New:h" .. fontsize
end
set_fontsize()

if vim.g.neovide then

    -- Cursor settings
    opt.guicursor =
    "n-v-c:block-Cursor-blinkwait300-blinkon200-blinkoff200," ..
    "i-ci:block-Cursor-blinkwait0," ..
    "r-cr:block-Cursor," ..
    "o:hor50-Cursor"

    g.neovide_theme                             = ''
    g.neovide_scale_factor                      = 1
    g.neovide_opacity                           = 1

    -- Disable visual bloat
    g.neovide_floating_blur_amount_x            = 0
    g.neovide_floating_blur_amount_y            = 0
    g.neovide_floating_z_height                 = 0
    g.neovide_light_angle_degrees               = 0
    g.neovide_light_radius                      = 0
    g.neovide_floating_shadow                   = false
    g.neovide_window_blurred                    = false


    -- Refresh rate
    g.neovide_refresh_rate                      = 120
    g.neovide_refresh_rate_idle                 = 60

    -- Animations (disabled for now)
    g.neovide_position_animation_length         = 0.05
    g.neovide_scroll_animation_length           = 0.05
    g.neovide_scroll_animation_far_lines        = 0.05
    g.neovide_cursor_animation_length           = 0.25
    g.neovide_underline_stroke_scale            = 0
    g.neovide_cursor_trail_size                 = 3

    -- Cursor VFX (disabled for now)
    g.neovide_cursor_vfx_particle_density       = 0
    g.neovide_cursor_vfx_opacity                = 0
    g.neovide_cursor_vfx_particle_lifetime      = 0
    g.neovide_cursor_vfx_mode                   = ""

    -- Cursor behavior
    g.neovide_cursor_animate_in_insert_mode     = false  -- subtle insert mode animation
    g.neovide_cursor_animate_command_line       = false
    g.neovide_cursor_smooth_blink               = false   -- blink looks smoother at 120Hz
    g.neovide_cursor_unfocused_outline_width    = 0

    g.neovide_progress_bar_enabled              = false
    g.neovide_progress_bar_height               = 0
    g.neovide_progress_bar_animation_speed      = 0

    -- Input & performance
    g.neovide_input_use_logo                    = false
    g.neovide_no_idle                           = false
    g.neovide_cursor_antialiasing               = false


    g.neovide_hide_mouse_when_typing            = true
end
