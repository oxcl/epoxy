-- Minimal SomeWM configuration

-- Libraries
local awful = require("awful")
require("awful.autofocus")

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
