local wezterm = require('wezterm')
local config = {}
require('events')

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  --[=====[
	Setting the term to wezterm is what allows support for undercurl

	BEFORE you can set the term to wezterm, you need to install a copy of the
	wezterm TERM definition
	https://wezfurlong.org/wezterm/config/lua/config/term.html?h=term

	If you're using tmux, set your tmux.conf file to:
	set -g default-terminal "${TERM}"
	So that it picks up the wezterm TERM we're defining here

	When inside neovim, run a `checkhealth` and under `tmux` you will see that
	the term is set to `wezterm`. If the term is set to something else:
	Reload your tmux configuration, then close all your tmux sessions to quit the
	terminal and re-open it
  --]=====]

  -- term = 'wezterm',

  -- default_prog = {
  --   '/usr/bin/zsh',
  --   '--login',
  --   '-c',
  --   [[
  --   if command -v tmux >/dev/null 2>&1; then
  --     tmux attach || tmux new;
  --   else
  --     exec zsh;
  --   fi
  --   ]],
  -- },

  color_scheme = 'Catppuccin Frappe',
  default_cursor_style = 'SteadyBar',
  automatically_reload_config = true,
  window_close_confirmation = 'NeverPrompt',
  adjust_window_size_when_changing_font_size = false,
  window_decorations = 'RESIZE',
  check_for_updates = false,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,

  -- cursor_blink_ease_out = 'Constant',
  -- cursor_blink_ease_in = 'Constant',
  -- cursor_blink_rate = 400,

  font_size = 12,
  font = wezterm.font('MesloLGS Nerd Font', { weight = 'Medium', stretch = 'Normal', style = 'Normal' }),

  enable_tab_bar = false,
  window_padding = {
    left = 2,
    right = 2,
    top = 5,
    bottom = 0,
  },
  background = {
    {
      source = {
        File = '/home/' .. os.getenv('USER') .. '/.config/wezterm/moon.jpg',
      },
      hsb = {
        hue = 1.0,
        saturation = 1.02,
        brightness = 0.25,
      },
      -- attachment = { Parallax = 0.3 },
      -- width = "100%",
      -- height = "100%",
    },
    {
      source = {
        Color = '#282c35',
      },
      width = '100%',
      height = '100%',
      opacity = 0.90,
    },
  },
  -- from: https://akos.ma/blog/adopting-wezterm/
  hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = '\\((\\w+://\\S+)\\)',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = '\\[(\\w+://\\S+)\\]',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = '\\{(\\w+://\\S+)\\}',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = '<(\\w+://\\S+)>',
      format = '$1',
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      -- Before
      --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
      --format = '$0',
      -- After
      regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
      format = '$1',
      highlight = 1,
    },
    -- implicit mailto link
    {
      regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
      format = 'mailto:$0',
    },
  },
}
return config
