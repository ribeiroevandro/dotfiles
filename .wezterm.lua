local wezterm = require 'wezterm'

return {
  -- ...your existing config
  color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
  enable_tab_bar = false,
  font = wezterm.font('JetBrains Mono'),
  font_size = 14,
  window_close_confirmation = 'NeverPrompt'
}
