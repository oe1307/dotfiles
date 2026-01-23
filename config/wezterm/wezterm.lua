local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.use_ime = false
config.font_size = 18.0
config.audible_bell = "Disabled"
config.font = wezterm.font("HackGen Console NF")
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.color_scheme = "iTerm2 Smoooooth"
config.inactive_pane_hsb = { brightness = 0.3 }
config.notification_handling = "AlwaysShow"
config.mouse_bindings = {
    {
        -- Disable move window
        event = { Drag = { streak = 1, button = "Left" } },
        mods = "CMD",
        action = wezterm.action.DisableDefaultAssignment,
    },
    {
        -- Disable open url
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = wezterm.action.DisableDefaultAssignment,
    },
}
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
