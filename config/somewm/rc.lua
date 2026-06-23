-- Minimal SomeWM configuration

-- Libraries
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local ruled = require("ruled")
local gears = require("gears")

-- Initialize theme
beautiful.init({
    -- Flexoki colors
    bg_normal   = "#1C1B1A",  -- base-950
    fg_normal   = "#B7B5AC",  -- base-300
    bg_focus    = "#879A39",  -- green-400
    fg_focus    = "#FFFCF0",  -- paper
    bg_urgent   = "#AF3029",  -- red-600
    fg_urgent   = "#FFFCF0",  -- paper

    -- Window borders
    border_width  = 2,
    border_normal = "#403E3C",  -- base-800
    border_focus  = "#879A39",  -- green-400

    -- Gaps
    useless_gap = 6,

    -- Titlebar
    titlebar_bg = "#282726",  -- base-900
})

-- Default program
terminal = "foot"

-- Modifier key
modkey = "Mod4"

-- Table with layouts to use
local layouts = {
    awful.layout.suit.tile,
}

-- Tags
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, layouts[1])
end)

-- Keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ "Control" }, "n", function()
        awful.spawn(terminal)
    end, { description = "open foot terminal", group = "launcher" }),
})

-- Focus follows mouse
client.connect_signal("mouse::enter", function(c)
    c:activate({ context = "mouse_enter", raise = false })
end)

-- Client mouse bindings
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate({ context = "mouse_click" })
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate({ context = "mouse_click", action = "mouse_move" })
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate({ context = "mouse_click", action = "mouse_resize" })
        end),
    })
end)

-- Client rules
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule({
        rule = {},
        properties = {
            titlebars_enabled = true,
            shape = function(cr, w, h)
                gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 10)
            end,
        },
    })
end)

-- Titlebars
client.connect_signal("request::titlebars", function(c)
    local close_button = wibox.widget {
        markup = '<span color="#AF3029">✕</span>',
        widget = wibox.widget.textbox,
    }
    awful.titlebar(c, { size = 28 }).widget = {
        { awful.titlebar.widget.iconwidget(c), layout = wibox.layout.fixed.horizontal },
        { awful.titlebar.widget.titlewidget(c), layout = wibox.layout.flex.horizontal },
        {
            {
                close_button,
                margins = 4,
                widget = wibox.container.margin,
            },
            buttons = {
                awful.button({}, 1, function()
                    c:kill()
                end),
            },
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
