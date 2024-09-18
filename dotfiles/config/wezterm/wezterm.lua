local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.audible_bell = "Disabled"
config.use_ime = false
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 16.0
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.color_scheme = "iTerm2 Smoooooth"
config.keys = {
    { key = "¥", action = wezterm.action({ SendString = "\\" }) },
    { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
    { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
    { key = "LeftArrow", mods = "CMD", action = wezterm.action({ SendString = "\x01" }) },
    { key = "RightArrow", mods = "CMD", action = wezterm.action({ SendString = "\x05" }) },
}
return config
