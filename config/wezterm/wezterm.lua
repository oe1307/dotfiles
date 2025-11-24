local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.audible_bell = "Disabled"
config.font = wezterm.font("Hack Nerd Font Mono")
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.color_scheme = "iTerm2 Smoooooth"
config.inactive_pane_hsb = { brightness = 0.3 }
config.notification_handling = "AlwaysShow"
config.mouse_bindings = {
    {
        event = { Drag = { streak = 1, button = "Left" } },
        mods = "CMD",
        action = wezterm.action.DisableDefaultAssignment,
    },
}
config.use_ime = false
config.font_size = 16.0
config.keys = {
    { key = "¥", action = wezterm.action({ SendString = "\\" }) },
    { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "^", mods = "CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "+", mods = "CMD|SHIFT", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
    { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
    { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
    { key = "LeftArrow", mods = "CMD", action = wezterm.action({ SendString = "\x01" }) },
    { key = "RightArrow", mods = "CMD", action = wezterm.action({ SendString = "\x05" }) },
}

return config
