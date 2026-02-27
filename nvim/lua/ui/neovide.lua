if vim.g.neovide then
    local o = vim.o
    local opt = vim.opt
    local keymap = vim.keymap.set
    local g = vim.g

    -- --- Font Configuration & Cycling ---
    local fonts = {
        "JetBrainsMono_Nerd_Font_Mono:h13",
        "AnonymicePro_Nerd_Font_Mono:h13",
        "LiterationMono_Nerd_Font_Mono:h13",
        "Monaspace_Argon_NF:h13"
    }

    local current_font_idx = 1

    o.guifont = fonts[current_font_idx]
    opt.linespace = -6

    -- Scale Factor
    g.neovide_scale_factor = 1

    -- Transparency & Blur (Set to 0/false per your request)
    g.neovide_opacity = 1
    g.neovide_window_blurred = false
    g.neovide_floating_blur_amount_x = 0
    g.neovide_floating_blur_amount_y = 0

    -- Floating Shadow
    g.neovide_floating_shadow = false
    g.neovide_floating_z_height = 0
    g.neovide_light_angle_degrees = 0
    g.neovide_light_radius = 0

    -- Performance
    g.neovide_refresh_rate = 60
    g.neovide_refresh_rate_idle = 10
    g.neovide_no_idle = false
    g.neovide_remember_window_size = false

    -- Padding
    g.neovide_padding_top = 0
    g.neovide_padding_left = 0
    g.neovide_padding_right = 0
    g.neovide_padding_bottom = 0

    -- Smooth Scrolling
    g.neovide_scroll_animation_length = 0.0
    g.neovide_scroll_animation_far_lines = 1

    -- Cursor Behavior & Animation
    g.neovide_hide_mouse_when_typing = true
    g.neovide_underline_stroke_scale = 1.0
    g.neovide_position_animation_length = 0
    g.neovide_cursor_animation_length = 0
    g.neovide_cursor_trail_size = 0
    g.neovide_cursor_antialiasing = true
    g.neovide_cursor_animate_in_insert_mode = true
    g.neovide_cursor_animate_command_line = true
    g.neovide_cursor_unfocused_outline_width = 0.12
    g.neovide_cursor_smooth_blink = false

    -- Cursor Particles (Nice Animation)
    g.neovide_cursor_vfx_mode = ""
    g.neovide_cursor_vfx_opacity = 200.0
    g.neovide_cursor_vfx_particle_lifetime = 1.2
    g.neovide_cursor_vfx_particle_density = 7.0

    -- Input & UI
    g.neovide_input_use_logo = true
    g.neovide_theme = 'dark'
    
    -- Progress Bar
    g.neovide_progress_bar_enabled = true
    g.neovide_progress_bar_height = 2.0
    g.neovide_progress_bar_animation_speed = 8.0

    opt.guicursor = "n-v-c:block-Cursor-blinkwait300-blinkon200-blinkoff150"

    -- --- Helper Functions & Keymaps ---

    local function get_font_size()
        local size = o.guifont:match(":h(%d+)")
        return size and tonumber(size) or 9
    end

    local function set_font_size(size)
        o.guifont = o.guifont:gsub(":h%d+", ":h" .. size)
    end

    keymap('n', '<C-=>', function()
        local size = get_font_size()
        set_font_size(size + 1)
    end, { silent = true, desc = "Increase font size" })

    keymap('n', '<C-->', function()
        local size = get_font_size()
        if size > 1 then set_font_size(size - 1) end
    end, { silent = true, desc = "Decrease font size" })

    keymap('n', '<C-0>', function()
        current_font_idx = 1
        o.guifont = fonts[current_font_idx]
    end, { silent = true, desc = "Reset font size and family" })

    keymap('n', '<F3>', function()
        local current_size = get_font_size()
        current_font_idx = current_font_idx + 1
        if current_font_idx > #fonts then current_font_idx = 1 end
        
        local new_font = fonts[current_font_idx]:gsub(":h%d+", ":h" .. current_size)
        o.guifont = new_font
        print("Font: " .. new_font)
    end, { silent = true, desc = "Cycle through fonts" })

    keymap('n', '<F11>', function()
        g.neovide_fullscreen = not g.neovide_fullscreen
    end, { silent = true, desc = "Toggle fullscreen" })
end
