local wezterm = require("wezterm")
local config = wezterm.config_builder()

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

local function state_path()
    local xdg = os.getenv("XDG_CONFIG_HOME")
    local home = os.getenv("HOME")
    local base = xdg or (home and (home .. "/.config")) or "."
    return base .. "/wezterm/use_ime_state"
end

local function read_state()
    local f = io.open(state_path(), "r")
    if not f then
        return nil
    end
    local s = f:read("*l")
    f:close()
    return s
end

local function write_state(v)
    local f = io.open(state_path(), "w")
    if not f then
        return
    end
    f:write(v and "1" or "0")
    f:close()
end

do
    local s = read_state()
    if s == "1" then
        config.use_ime = true
    elseif s == "0" then
        config.use_ime = false
    else
        config.use_ime = true
    end
end

wezterm.on("gui-startup", function(cmd)
    write_state(false)
    local tab, pane, mux_window = wezterm.mux.spawn_window(cmd or {})
    local window = mux_window:gui_window()
    local overrides = window:get_config_overrides() and (window:get_config_overrides() or {}) or {}
    overrides.use_ime = false
    window:set_config_overrides(overrides)
end)

wezterm.on("toggle-ime", function(window, pane)
    local current = window:effective_config().use_ime
    local nextv = not current
    write_state(nextv)
    local overrides = window:get_config_overrides() or {}
    overrides.use_ime = nextv
    window:set_config_overrides(overrides)
    -- window:toast_notification("WezTerm", "日本語: " .. tostring(overrides.use_ime), nil, 2500)
end)

config.keys = config.keys or {}
table.insert(config.keys, {
    key = "I",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("toggle-ime"),
})

return config
