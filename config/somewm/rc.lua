-- Minimal somewm config for epoxy dev environment

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Error" .. (startup and " during startup!" or "!"),
        message = message,
    }
end)

-- Theme
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Layouts
awful.layout.append_tag {
    name = "tile",
    layout = awful.layout.suit.tile,
}
awful.layout.append_tag {
    name = "max",
    layout = awful.layout.suit.max,
}
awful.layout.append_tag {
    name = "floating",
    layout = awful.layout.suit.floating,
}

-- Set defaults
awful.tag({ "1", "2", "3", "4", "5" , "6", "7", "8", "9" }, screen, awful.layout.suit.tile)

-- Keybindings
root.keys(gears.table.join(
    awful.key({ "Mod4" }, "Return", function() awful.spawn("foot") end,
        {description = "open terminal", group = "launcher"}),
    awful.key({ "Mod4" }, "r", function() awful.spawn("foot -e ranger") end,
        {description = "run prompt", group = "launcher"}),
    awful.key({ "Mod4" }, "j", function() awful.client.focus.byidx(1) end,
        {description = "focus next", group = "client"}),
    awful.key({ "Mod4" }, "k", function() awful.client.focus.byidx(-1) end,
        {description = "focus prev", group = "client"}),
    awful.key({ "Mod4", "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        {description = "swap next", group = "client"}),
    awful.key({ "Mod4", "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        {description = "swap prev", group = "client"}),
    awful.key({ "Mod4" }, "Space", function() awful.layout.inc(1) end,
        {description = "next layout", group = "layout"}),
    awful.key({ "Mod4", "Shift" }, "c", function() client.focus:kill() end,
        {description = "close", group = "client"}),
    awful.key({ "Mod4", "Shift" }, "q", awesome.quit,
        {description = "quit", group = "awesome"}),
    awful.key({ "Mod4", "Control" }, "r", awesome.restart,
        {description = "reload", group = "awesome"})
))

-- Tag keybindings
for i = 1, 9 do
    root.keys(gears.table.join(root.keys(),
        awful.key({ "Mod4" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
        end, {description = "view tag " .. i, group = "tag"}),
        awful.key({ "Mod4", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end, {description = "move client to tag " .. i, group = "tag"})
    ))
end

-- Rules
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id       = "global",
        rule     = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    }
end)

-- Focus follows mouse
awful.mouse.append_client_rules {
    id = "mouse_focus",
    rule = {},
    properties = { focus = awful.mouse.client.focus },
}
