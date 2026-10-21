-- Matches foot (foot/.config/foot/foot.ini): same font, padding, cursor,
-- no decorations, and colors from theme/palette via colors.lua.
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.colors = dofile(wezterm.config_dir .. "/colors.lua")
config.bold_brightens_ansi_colors = false

config.font = wezterm.font("LiterationMono Nerd Font Mono")
config.font_size = 15

-- foot: pad=20x20, no client-side decorations, no tab bar
config.window_padding = { left = 20, right = 20, top = 20, bottom = 20 }
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_background_opacity = 1.0

-- foot: block cursor, blinking every 500ms, no fade
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.animation_fps = 1

config.scrollback_lines = 20000
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "Disabled"
config.check_for_updates = false

return config
