if vim.g.neovide then
    local o                                     = vim.o
    local opt                                   = vim.opt
    local g                                     = vim.g
    
    -- Font
    o.guifont                                   = "LiterationMono_Nerd_Font_Mono:h12"  
    opt.linespace                               = 0
    
    -- Cursor settings
    opt.guicursor =
    "n-v-c:block-Cursor-blinkwait300-blinkon200-blinkoff200," ..
    "i-ci:ver25-Cursor-blinkwait0," ..
    "r-cr:hor20-Cursor," ..
    "o:hor50-Cursor"
    
    -- Theme
    g.neovide_theme                             = 'dark'
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
    
    -- Refresh rate (120Hz native to your display)
    g.neovide_refresh_rate                      = 120
    g.neovide_refresh_rate_idle                 = 10
    
    -- Animation timings (tuned for 120Hz smoothness)
    -- At 120Hz: 16.67ms per frame
    -- Maximizing smoothness and premium feel
    g.neovide_position_animation_length         = 0.25   -- window moves gracefully
    g.neovide_scroll_animation_length           = 0.9    -- scroll feels luxurious
    g.neovide_scroll_animation_far_lines        = 0.8    -- pane switches flow smoothly
    g.neovide_cursor_animation_length           = 0.25   -- cursor trails elegantly
    g.neovide_underline_stroke_scale            = 0.5
    g.neovide_cursor_trail_size                 = 1.5
    
    -- Cursor VFX (disabled for performance, but can tweak if desired)
    g.neovide_cursor_vfx_particle_density       = 0
    g.neovide_cursor_vfx_opacity                = 0
    g.neovide_cursor_vfx_particle_lifetime      = 0
    g.neovide_cursor_vfx_mode                   = ""
    
    -- Cursor behavior
    g.neovide_cursor_animate_in_insert_mode     = true   -- subtle insert mode animation
    g.neovide_cursor_animate_command_line       = true
    g.neovide_cursor_smooth_blink               = true   -- blink looks smoother at 120Hz
    g.neovide_cursor_unfocused_outline_width    = 0
    
    -- UI
    g.neovide_fullscreen                        = true
    g.neovide_progress_bar_enabled              = false
    g.neovide_progress_bar_height               = 0
    g.neovide_progress_bar_animation_speed      = 0
    
    -- Input & performance
    g.neovide_hide_mouse_when_typing            = true
    g.neovide_input_use_logo                    = false
    g.neovide_no_idle                           = false
    g.neovide_cursor_antialiasing               = false  -- sharp at native res
end
