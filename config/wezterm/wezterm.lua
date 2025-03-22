local wezterm = require("wezterm")
local config = wezterm.config_builder()
local is_windows <const> = wezterm.target_triple:find("windows") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil
local is_mac <const> = wezterm.target_triple:find("darwin") ~= nil

config.enable_wayland = false
config.audible_bell = "Disabled"
config.font = wezterm.font("Hack Nerd Font Mono")
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.color_scheme = "iTerm2 Smoooooth"
config.inactive_pane_hsb = { brightness = 0.3 }
config.mouse_bindings = {
    {
        event = { Drag = { streak = 1, button = "Left" } },
        mods = "CMD",
        action = wezterm.action.DisableDefaultAssignment,
    },
}

if is_mac then
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
end
if is_windows then
    -- ! edit in powershell
    config.default_prog = { "wsl" }
    config.font_size = 12.0
    config.keys = {
        { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "^", mods = "CTRL", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    }
end

return config
