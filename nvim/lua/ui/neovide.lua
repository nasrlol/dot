if vim.g.neovide then

  -- Font settings

  vim.g.neovide_scale_factor = 1.0
  vim.o.guifont = "Monaspace Krypton NF SemiWide:style=regular:h9"

  -- Cursor settings
  vim.g.neovide_cursor_animation_length = 0.2
  vim.g.neovide_cursor_antialiasing = true

  vim.g.neovide_cursor_trail_size = 1
  vim.g.neovide_cursor_animate_in_insert_mode = true

  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_mode = "ripplegun"
  vim.g.neovide_cursor_vfx_opacity = 400.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_density = 2.0
  vim.g.neovide_cursor_hack = true


  -- UI settings
  vim.g.neovide_floating_blur_amount_x = 9.0
  vim.g.neovide_floating_blur_amount_y = 9.0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate = 240
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_no_idle = true

  -- Transparency
  vim.g.neovide_opacity = 0.7
  vim.g.neovide_window_floating_opacity = 0.95
  vim.g.neovide_window_undecorated = true

  -- Input settings
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_touch_deadzone = 0.0
  vim.g.neovide_cursor_unfocused_outline_width = 0.125

  -- Key mappings for Neovide
  vim.keymap.set('n', '<C-+>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end, { silent = true })

  vim.keymap.set('n', '<C-->', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end, { silent = true })

  vim.keymap.set('n', '<C-0>', function()
    vim.g.neovide_scale_factor = 1.0
  end, { silent = true })

  vim.keymap.set('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { silent = true })
end

