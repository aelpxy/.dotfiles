local wezterm = require 'wezterm'

return {
  font = wezterm.font 'JetBrains Mono',
  font_size = 20,
  window_background_opacity = 0.7,
  macos_window_background_blur = 40,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,
  color_scheme = 'Tokyo Night',
  default_cursor_style = 'BlinkingBar',
  animation_fps = 1,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',

  keys = {
    { key = 'h', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  },
}
