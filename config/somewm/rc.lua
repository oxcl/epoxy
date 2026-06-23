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

-- Create taglist and tasklist widgets
local taglist_buttons = {
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, function(t) awful.tag.viewtoggle(t) end),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end),
}

local tasklist_buttons = {
    awful.button({}, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
    end),
    awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end),
}

-- Tags
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, layouts[1])
    
    -- Create taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            shape = gears.shape.rounded_rect,
            bg_focus = "#879a39",
            fg_focus = "#fffcf0",
            bg_urgent = "#af3029",
            fg_urgent = "#fffcf0",
            bg_occupied = "#282726",
            fg_occupied = "#cecdc3",
            bg_empty = "#1c1b1a",
            fg_empty = "#575653",
        },
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 4,
        },
        widget_template = {
            {
                {
                    {
                        { id = "text_role", widget = wibox.widget.textbox },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    margins = { left = 8, right = 8, top = 2, bottom = 2 },
                    widget = wibox.container.margin,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            margins = 2,
            widget = wibox.container.margin,
        },
    }
    
    -- Create tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape = gears.shape.rounded_rect,
            bg_focus = "#282726",
            fg_focus = "#cecdc3",
            bg_normal = "#1c1b1a",
            fg_normal = "#878580",
            border_width = 1,
            border_color = "#343331",
            border_focus = "#879a39",
        },
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 4,
        },
        widget_template = {
            {
                {
                    {
                        { id = "icon_role", widget = wibox.widget.imagebox },
                        { id = "text_role", widget = wibox.widget.textbox },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    margins = { left = 8, right = 8, top = 2, bottom = 2 },
                    widget = wibox.container.margin,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            margins = 2,
            widget = wibox.container.margin,
        },
    }
    
    -- Create wibar (top bar)
    s.mywibox = awful.wibar {
        position = "top",
        screen = s,
        height = 32,
        bg = "#100f0f",
        fg = "#cecdc3",
        border_width = 1,
        border_color = "#282726",
        widget = {
            layout = wibox.layout.align.horizontal,
            { -- Left section: taglist
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
            },
            { -- Center section: tasklist
                layout = wibox.layout.flex.horizontal,
                s.mytasklist,
            },
            { -- Right section: clock, systray, layout
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.textclock(),
                awful.widget.layoutbox {
                    buttons = {
                        awful.button({}, 1, function() awful.layout.inc(1) end),
                        awful.button({}, 3, function() awful.layout.inc(-1) end),
                        awful.button({}, 4, function() awful.layout.inc(1) end),
                        awful.button({}, 5, function() awful.layout.inc(-1) end),
                    }
                },
            },
        },
    }
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
